{
  lib,
  mkShell,
  nixosTests,
  python3,
  python3Packages,
  ruff,
  makeWrapper,
  bubblewrap,
}:

python3Packages.buildPythonApplication {
  __structuredAttrs = true;

  name = "nixos-secrets";
  format = "pyproject";
  nativeBuildInputs = [
    python3Packages.setuptools
    makeWrapper
  ];
  src = ./src;

  postFixup = ''
    wrapProgram $out/bin/nixos-secrets \
      --prefix PATH : ${bubblewrap}/bin
  '';

  passthru.devShell = mkShell {
    packages = [
      python3
      bubblewrap
      ruff
    ];
  };

  passthru.tests = {
    inherit (nixosTests)
      nixos-secrets-basic-generators
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
