{
  python3Packages,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      lxmf = super.lxmf.override {
        propagateRns = false;
      };
    }
  );
in
pythonPackages.toPythonApplication (
  pythonPackages.rns.overridePythonAttrs (old: {
    dependencies = old.dependencies ++ [
      pythonPackages.lxmf
    ];
  })
)
