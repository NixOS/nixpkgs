{ python3Packages, ... }@args:
with python3Packages;
toPythonApplication (dvc.override (builtins.removeAttrs args [ "python3Packages" ]))
