{
  cargo,
  lib,
  runCommand,
  rustPlatform,
  stdenv,
  writeText,
}:
rec {
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

  cargoSetupHook-invalid-config =
    let
      sys = lib.systems.elaborate stdenv.system;
      invalidCargoConfig = writeText "invalid-cargo-config.toml" ''
        [target.${sys.linuxArch}-unknown-linux-gnu]
        linker = "${sys.linuxArch}-linux-gnu-gcc"
      '';
      invalidSrc = runCommand "invalid-src" { } ''
        cp -r ${./example-rust-project} $out
        chmod -R +w $out
        mkdir -p $out/.cargo
        cp ${invalidCargoConfig} $out/.cargo/config.toml
      '';
    in
    cargoSetupHook.overrideAttrs (old: {
      src = invalidSrc;
    });

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
