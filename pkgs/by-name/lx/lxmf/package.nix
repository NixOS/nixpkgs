{
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      lxmf = super.lxmf.override {
        propagateRns = true;
      };
    }
  );
in
pythonPackages.toPythonApplication pythonPackages.lxmf
