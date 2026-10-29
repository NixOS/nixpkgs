{
  lib,
  mkShell,
  nixosTests,
  python3,
  python3Packages,
  ruff,
  mypy,
  makeWrapper,
  bubblewrap,
  jsonschema,
}:

python3Packages.buildPythonApplication {
  __structuredAttrs = true;

  name = "nixos-secrets";
  format = "pyproject";
  src = ./src;

  nativeBuildInputs = [
    python3Packages.setuptools
    makeWrapper
    ruff
    mypy
  ];

  postFixup = ''
    wrapProgram $out/bin/nixos-secrets \
      --prefix PATH : ${
        lib.makeBinPath [
          bubblewrap
          jsonschema
        ]
      }
  '';

  checkPhase = ''
    ruff check $src
    mypy $src
  '';

  passthru.devShell = mkShell {
    packages = [
      python3
      bubblewrap
      ruff
      mypy
      jsonschema
    ];
  };

  passthru.tests = {
    inherit (nixosTests)
      nixos-secrets-basic-generators
      nixos-secrets-failure-recovery
      ;
  };

  # This is perhaps not a good idea?
  passthru.jsonify = import ./src/nixos_secrets/nix/jsonify.nix;

  meta = {
    description = "NixOS secret management abstraction";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/by-name/ni/nixos-secrets";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lassulus
      prescientmoon
    ];
    mainProgram = "nixos-secrets";
  };
}
