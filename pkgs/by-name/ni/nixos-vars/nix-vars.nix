{
  lib,
  buildPythonApplication,
  setuptools,
}:

buildPythonApplication {
  name = "nix-vars";
  format = "pyproject";
  nativeBuildInputs = [ setuptools ];
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./nix_vars
      ./pyproject.toml
    ];
  };

  postInstall = ''
    cp -r nix_vars/nix $out/lib/python3.13/site-packages/nix_vars
  '';
}
