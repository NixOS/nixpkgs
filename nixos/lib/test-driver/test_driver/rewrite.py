import ast
import types
import typing

# inspired by https://github.com/pytest-dev/pytest/blob/main/src/_pytest/assertion/rewrite.py


def rewrite_and_compile_python_test_code(source: str) -> types.CodeType:
    tree = ast.parse(source, filename="<stdin>")
    rewrite_test_code_ast(tree)
    ast.fix_missing_locations(tree)
    return compile(tree, "<stdin>", "exec", dont_inherit=True)


def rewrite_test_code_ast(node: ast.AST) -> None:  # mutates node
    """
    Applies rewrite_assert_stmt to all ast.Assert statements in node
    """
    assert isinstance(node, ast.AST)

    if isinstance(node, ast.Module):
        if not node.body:
            return

    # recurse
    if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef, ast.ClassDef)):
        rewrite_test_code_ast(node)

    # traverse
    else:
        for name, field in ast.iter_fields(node):
            # expressions can't contain (assert) statements
            if isinstance(field, ast.expr):
                continue

            # find asserts, rewrite or recurse
            if isinstance(field, list):
                new_field: list[ast.AST] = []
                for i, child in enumerate(field):
                    if isinstance(child, ast.Assert):
                        new_field += rewrite_assert_stmt(child)
                    else:
                        new_field.append(child)
                        rewrite_test_code_ast(child)
                setattr(node, name, new_field)


CMPOP_TO_STR: dict[type[ast.cmpop], str] = {
    ast.Eq: "==",
    ast.NotEq: "!=",
    ast.Is: "is",
    ast.IsNot: "is not",
    ast.Lt: "<",
    ast.LtE: "<=",
    ast.Gt: ">",
    ast.GtE: ">=",
}

_VARIABLE_NAME_COUNTER: int = 0


def _mk_var_name() -> str:
    global _VARIABLE_NAME_COUNTER
    _VARIABLE_NAME_COUNTER += 1
    # Use a character invalid in python identifiers to avoid name clashes
    return f"@nixos_test_assert_{_VARIABLE_NAME_COUNTER}"


def rewrite_assert_stmt(assert_node: ast.Assert) -> typing.Iterable[ast.stmt]:
    """
    Converts an assert statement into a sequence of statements

        assert x == y != z

    becomes

        @nixos_test_assert_1 = x
        @nixos_test_assert_2 = y
        assert @nixos_test_assert_1 == @nixos_test_assert_2, \
            f"(x == y)\n  {@nixos_test_assert_1!r} == {@nixos_test_assert_2!r}"
        @nixos_test_assert_3 = z
        assert @nixos_test_assert_2 != @nixos_test_assert_3, \
            f"(y != z)\n  {@nixos_test_assert_2!r} != {@nixos_test_assert_3!r}"

    Supported operands: ==, !=, is, is not, >, <, >=, >=
    """
    assert isinstance(assert_node, ast.Assert)

    # in this case we already have a warning raised by python:
    #     SyntaxWarning: assertion is always true, perhaps remove parentheses?
    if isinstance(assert_node.test, ast.Tuple) and len(assert_node.test.elts) >= 1:
        yield assert_node
        return

    # the assert already has a message
    if assert_node.msg is not None:
        yield assert_node
        return

    # if the assert is not one of the supported binary comparision ops, ignore
    if not isinstance(assert_node.test, ast.Compare) or not all(
        isinstance(op, (*CMPOP_TO_STR.keys(),)) for op in assert_node.test.ops
    ):
        yield assert_node
        return

    test_lhs_node: ast.expr = assert_node.test.left
    test_rhs_nodes: list[ast.expr] = assert_node.test.comparators

    # precompute lhs
    test_lhs_name: str = _mk_var_name()
    yield ast.Assign(
        targets=[ast.Name(id=test_lhs_name, ctx=ast.Store())],
        value=test_lhs_node,
        lineno=assert_node.lineno,
        end_lineno=assert_node.end_lineno,
    )

    # for each comparision, emit an assert with a more specific message
    for i, (cmpop, test_rhs_node) in enumerate(
        zip(assert_node.test.ops, test_rhs_nodes)
    ):
        test_rhs_name: str = _mk_var_name()

        # precompute rhs
        yield ast.Assign(
            targets=[ast.Name(id=test_rhs_name, ctx=ast.Store())],
            value=test_rhs_node,
            lineno=assert_node.lineno,
            end_lineno=assert_node.end_lineno,
        )

        if len(test_rhs_nodes) > 1:
            subexpr = ast.Compare(
                left=test_lhs_node, ops=[cmpop], comparators=[test_rhs_node]
            )
            msg_prefix = f"( {ast.unparse(subexpr)} )\n  "
        else:
            msg_prefix = ""

        # assert lhs op rhs, f"{lhs"r} op {rhs!r}"
        yield ast.Assert(
            test=ast.Compare(
                left=ast.Name(id=test_lhs_name, ctx=ast.Load()),
                ops=[cmpop],
                comparators=[ast.Name(id=test_rhs_name, ctx=ast.Load())],
            ),
            msg=ast.JoinedStr(
                values=[
                    ast.Constant(value=msg_prefix),
                    ast.FormattedValue(
                        value=ast.Name(id=test_lhs_name, ctx=ast.Load()),
                        conversion=114,  # `!r` repr formatting
                    ),
                    ast.Constant(value=f" {CMPOP_TO_STR[cmpop.__class__]} "),
                    ast.FormattedValue(
                        value=ast.Name(id=test_rhs_name, ctx=ast.Load()),
                        conversion=114,  # `!r` repr formatting
                    ),
                ],
            ),
            lineno=assert_node.lineno,
            end_lineno=assert_node.end_lineno,
        )

        # set current rhs to next lhs
        test_lhs_name = test_rhs_name
        test_lhs_node = test_rhs_node
