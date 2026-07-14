{
  lib,
  buildPythonApplication,
  setuptools,
  makeWrapper,
  bubblewrap,
}:

buildPythonApplication {
  name = "nix-vars";
  format = "pyproject";
  nativeBuildInputs = [
    setuptools
    makeWrapper
  ];
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./nix_vars
      ./pyproject.toml
    ];
  };

  postFixup = ''
    wrapProgram $out/bin/nix-vars \
      --prefix PATH : ${bubblewrap}/bin
  '';
}
