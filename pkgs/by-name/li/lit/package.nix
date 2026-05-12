{ python3Packages, ... }@args:
with python3Packages;
toPythonApplication (lit.override (builtins.removeAttrs args [ "python3Packages" ]))
