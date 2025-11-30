import ast
import sys
from pathlib import Path

"""
This program takes all the Machine class methods and prints its methods in
markdown-style. These can then be included in the NixOS test driver
markdown style, assuming the docstrings themselves are also in markdown.

These are included in the test driver documentation in the NixOS manual.
See https://nixos.org/manual/nixos/stable/#ssec-machine-objects

The python input looks like this:

```py
...

class Machine(...):
    ...

    def some_function(self, param1, param2):
        ""
        documentation string of some_function.
        foo bar baz.
        ""
        ...
```

Output will be:

```markdown
...

some_function(param1, param2)

:   documentation string of some_function.
    foo bar baz.

...
```

"""


def main() -> None:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-test-driver>")
        sys.exit(1)

    module = ast.parse(Path(sys.argv[1]).read_text())

    class_definitions = (node for node in module.body if isinstance(node, ast.ClassDef))

    machine_class = next(filter(lambda x: x.name == "Machine", class_definitions))
    assert machine_class is not None

    function_definitions = [
        node for node in machine_class.body if isinstance(node, ast.FunctionDef)
    ]
    function_definitions.sort(key=lambda x: x.name)

    for function in function_definitions:
        docstr = ast.get_docstring(function)
        if docstr is not None:
            args = ", ".join(a.arg for a in function.args.args[1:])
            args = f"({args})"

            docstr = "\n".join(f"    {line}" for line in docstr.strip().splitlines())

            print(f"{function.name}{args}\n\n:{docstr[1:]}\n")


if __name__ == "__main__":
    main()
