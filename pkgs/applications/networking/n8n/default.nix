{ pkgs, stdenv, lib, nixosTests }:

let
  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages.n8n.override {
  nativeBuildInputs = [
    pkgs.nodePackages.node-pre-gyp
    pkgs.which
  ];

  buildInputs = [
    pkgs.libkrb5
    pkgs.libmongocrypt
    pkgs.postgresql
  ];

  # Oracle's official package on npm is binary only (WHY?!) and doesn't provide binaries for aarch64.
  # This can supposedly be fixed by building a custom copy of the module from source, but that's way
  # too much complexity for a setup no one would ever actually run.
  #
  # NB: If you _are_ actually running n8n on Oracle on aarch64, feel free to submit a patch.
  preRebuild = lib.optionalString stdenv.isAarch64 ''
    rm -rf node_modules/oracledb
  '';

  # makes libmongocrypt bindings not look for static libraries in completely wrong places
  BUILD_TYPE = "dynamic";

  dontNpmInstall = true;

  passthru = {
    updateScript = ./generate-dependencies.sh;
    tests = nixosTests.n8n;
  };

  meta = with lib; {
    description = "Free and source-available fair-code licensed workflow automation tool. Easily automate tasks across different services.";
    maintainers = with maintainers; [ freezeboy k900 ];
    license = licenses.sustainableUse;
    mainProgram = "n8n";
  };
}
