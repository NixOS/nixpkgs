import ast
import sys

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

assert len(sys.argv) == 2

with open(sys.argv[1], "r") as f:
    module = ast.parse(f.read())

class_definitions = (node for node in module.body if isinstance(node, ast.ClassDef))

machine_class = next(filter(lambda x: x.name == "Machine", class_definitions))
assert machine_class is not None

function_definitions = [
    node for node in machine_class.body if isinstance(node, ast.FunctionDef)
]
function_definitions.sort(key=lambda x: x.name)

for f in function_definitions:
    docstr = ast.get_docstring(f)
    if docstr is not None:
        args = ", ".join((a.arg for a in f.args.args[1:]))
        args = f"({args})"

        docstr = "\n".join((f"    {l}" for l in docstr.strip().splitlines()))

        print(f"{f.name}{args}\n\n:{docstr[1:]}\n")
