import ast
import sys
from pathlib import Path
from typing import List

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

def function_docstrings(functions: List[ast.FunctionDef]) -> str | None:
    """Extracts docstrings from a list of function definitions."""
    documented_functions = [f for f in functions if ast.get_docstring(f) is not None]

    if not documented_functions:
        return None

    docstrings = []
    for function in documented_functions:
        docstr = ast.get_docstring(function)
        assert docstr is not None

        args = ", ".join(a.arg for a in function.args.args[1:])
        args = f"({args})"

        docstr = "\n".join(f"    {line}" for line in docstr.strip().splitlines())

        docstrings.append(f"{function.name}{args}\n\n:{docstr[1:]}\n")
    return "\n".join(docstrings)

def machine_methods(class_name: str, class_definitions: List[ast.ClassDef]) -> List[ast.FunctionDef]:
    """Given a class name and a list of class definitions, returns the list of function definitions
    for the class matching the given name.
    """
    machine_class = next(filter(lambda x: x.name == class_name, class_definitions))
    assert machine_class is not None

    function_definitions = [
        node for node in machine_class.body if isinstance(node, ast.FunctionDef)
    ]
    function_definitions.sort(key=lambda x: x.name)
    return function_definitions

def main() -> None:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-test-driver>")
        sys.exit(1)

    module = ast.parse(Path(sys.argv[1]).read_text())

    class_definitions = [node for node in module.body if isinstance(node, ast.ClassDef)]

    base_machine_methods = machine_methods("BaseMachine", class_definitions)
    base_method_names = {method.name for method in base_machine_methods}

    qemu_machine_methods = [
        method for method in machine_methods("QemuMachine", class_definitions)
        if method.name not in base_method_names
    ]

    nspawn_machine_methods = [
        method for method in machine_methods("NspawnMachine", class_definitions)
        if method.name not in base_method_names
    ]

    print("#### Generic machine objects {#ssec-all-machine-objects} \n")
    print(function_docstrings(base_machine_methods))
    print("#### QEMU VM objects {#ssec-qemu-machine-objects}\n")
    print(function_docstrings(qemu_machine_methods) or "No methods specific to QEMU virtual machines.")
    print("#### `systemd-nspawn` container objects {#ssec-nspawn-machine-objects}\n")
    print(function_docstrings(nspawn_machine_methods) or "No methods specific to `systemd-nspawn` containers.")

if __name__ == "__main__":
    main()
