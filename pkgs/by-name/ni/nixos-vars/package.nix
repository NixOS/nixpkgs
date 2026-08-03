{
  mkShell,
  nixosTests,
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
  src = ./src;

  postFixup = ''
    wrapProgram $out/bin/nix-vars \
      --prefix PATH : ${bubblewrap}/bin
  '';

  passthru.devShell = mkShell {
    packages = [
      python3
      bubblewrap
      ruff
      age # Here to ease playing with the age backend
    ];
  };

  passthru.tests = {
    inherit (nixosTests)
      nixos-vars-basic-generators
      ;
  };

  # This is perhaps not a good idea?
  passthru.jsonify = import ./src/nix_vars/nix/jsonify.nix;
}
