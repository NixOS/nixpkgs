{
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      chardet = self.chardet_5;
    }
  );
in
with pythonPackages;
toPythonApplication clevercsv
