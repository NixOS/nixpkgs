{
  python3Packages,
  ...
}@args:

python3Packages.toPythonApplication (
  python3Packages.beets.override (builtins.removeAttrs args [ "python3Packages" ])
)
