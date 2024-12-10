{
  pkgs,
  stdenv,
  lib,
  nixosTests,
}:

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
    pkgs.xcbuild
  ];

  buildInputs = [
    pkgs.libkrb5
    pkgs.libmongocrypt
    pkgs.postgresql
  ];

  preRebuild = lib.optionalString stdenv.isAarch64 ''
    # Oracle's official package on npm is binary only (WHY?!) and doesn't provide binaries for aarch64.
    # This can supposedly be fixed by building a custom copy of the module from source, but that's way
    # too much complexity for a setup no one would ever actually run.
    #
    # NB: If you _are_ actually running n8n on Oracle on aarch64, feel free to submit a patch.
    rm -rf node_modules/oracledb

    # This package tries to load a prebuilt binary for a different arch, and it doesn't provide the binary for aarch64.
    # It is marked as an optional dependency in pnpm-lock.yaml and there are no other references to it n8n.
    rm -rf node_modules/@sap/hana-client
  '';

  # makes libmongocrypt bindings not look for static libraries in completely wrong places
  BUILD_TYPE = "dynamic";

  # Disable NAPI_EXPERIMENTAL to allow to build with Node.js≥18.20.0.
  NIX_CFLAGS_COMPILE = "-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT";

  dontNpmInstall = true;

  passthru = {
    updateScript = ./generate-dependencies.sh;
    tests = nixosTests.n8n;
  };

  meta = with lib; {
    description = "Free and source-available fair-code licensed workflow automation tool. Easily automate tasks across different services.";
    maintainers = with maintainers; [
      freezeboy
      k900
    ];
    license = licenses.sustainableUse;
    mainProgram = "n8n";
  };
}
