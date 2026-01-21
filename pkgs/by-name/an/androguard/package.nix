{
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      sqlalchemy = self.sqlalchemy_1_4;
    }
  );
in
pythonPackages.toPythonApplication pythonPackages.androguard
