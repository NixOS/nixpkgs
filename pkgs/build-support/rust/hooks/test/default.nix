{
  rustPlatform,
  stdenv,
  cargo,
  lib,
  pkg-config,
  buildPackages,
  zlib,
}:
{
  /*
    test each hook individually, to make sure that:
      - each hook works properly outside of buildRustPackage
      - each hook is usable independently from each other
  */
  cargoSetupHook = stdenv.mkDerivation {
    name = "test-cargoSetupHook";
    src = ./example-rust-project;
    cargoVendorDir = "hello";
    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      cargo
    ];
    buildPhase = ''
      cargo build --profile release --target ${stdenv.hostPlatform.rust.rustcTarget}
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/hello $out/bin/
    '';
  };

  cargoSetupHookPkgConfig = stdenv.mkDerivation {
    name = "test-cargoSetupHook-pkg-config";
    strictDeps = true;
    dontCargoSetupPostUnpack = true;
    dontCargoUseSystemLibs = true;
    cargoVendorDir = ".";
    depsBuildBuild = [ pkg-config ];
    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      pkg-config
      zlib
    ];
    buildInputs = [ zlib ];

    phases = [
      "configurePhase"
      "installPhase"
    ];
    postConfigure = ''
      test "$("$HOST_PKG_CONFIG" --variable=includedir zlib)" = "${lib.getDev buildPackages.zlib}/include"
      test "$("$PKG_CONFIG" --variable=includedir zlib)" = "${lib.getDev zlib}/include"
    '';
    installPhase = ''
      touch "$out"
    '';
  };

  cargoBuildHook = stdenv.mkDerivation {
    name = "test-cargoBuildHook";
    src = ./example-rust-project;
    cargoBuildType = "release";
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    nativeBuildInputs = [
      rustPlatform.cargoBuildHook
      cargo
    ];
    installPhase = ''
      mkdir -p $out/bin
      mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/hello $out/bin/
    '';
  };

  cargoInstallHook = stdenv.mkDerivation {
    name = "test-cargoInstallHook";
    src = ./example-rust-project;
    cargoBuildType = "release";
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    nativeBuildInputs = [
      rustPlatform.cargoInstallHook
      cargo
    ];
    buildPhase = ''
      cargo build --profile release --target ${stdenv.hostPlatform.rust.rustcTarget}
      runHook postBuild
    '';
  };

  cargoCheckHook = stdenv.mkDerivation {
    name = "test-cargoCheckHook";
    src = ./example-rust-project;
    cargoBuildType = "release";
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    nativeBuildInputs = [
      rustPlatform.cargoCheckHook
      cargo
    ];
    buildPhase = ''
      cargo build --profile release --target ${stdenv.hostPlatform.rust.rustcTarget}
      runHook postBuild
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/hello $out/bin/
    '';
    cargoCheckType = "release";
    doCheck = true;
  };

  cargoNextestHook = stdenv.mkDerivation {
    name = "test-cargoNextestHook";
    src = ./example-rust-project;
    cargoBuildType = "release";
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
    nativeBuildInputs = [
      rustPlatform.cargoNextestHook
      cargo
    ];
    buildPhase = ''
      cargo build --profile release --target ${stdenv.hostPlatform.rust.rustcTarget}
      runHook postBuild
    '';
    installPhase = ''
      mkdir -p $out/bin
      mv target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/hello $out/bin/
    '';
    cargoCheckType = "release";
    doCheck = true;
  };
}
