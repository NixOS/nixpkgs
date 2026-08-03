{
  lib,
  mkShell,
  python3,
  python3Packages,
  ruff,
  age,
  makeWrapper,
  bubblewrap,
}:

python3Packages.buildPythonApplication {
  name = "nix-vars";
  format = "pyproject";
  nativeBuildInputs = [
    python3Packages.setuptools
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

  passthru.devShell = mkShell {
    packages = [
      python3
      bubblewrap
      ruff # Formatter
      age # Here to ease playing with the age backend
    ];
  };
}
