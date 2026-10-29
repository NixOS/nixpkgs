{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  hdr10plus_tool,
  cargo-c,
  fontconfig,
}:

let
  inherit (lib) optionals concatStringsSep;
  inherit (buildPackages.rust.envVars) setEnv;
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "hdr10plus";
  # Version of the library, not the tool
  # See https://github.com/quietvoid/hdr10plus_tool/blob/main/hdr10plus/Cargo.toml
  version = "2.1.4";

  outputs = [
    "out"
    "dev"
  ];

  inherit (hdr10plus_tool) src cargoDeps cargoHash;

  nativeBuildInputs = [ cargo-c ];
  buildInputs = [ fontconfig ];

  cargoCFlags = [
    "--package=hdr10plus"
    "--frozen"
    "--prefix=${placeholder "out"}"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfigdir=${placeholder "dev"}/lib/pkgconfig"
    "--target=${stdenv.hostPlatform.rust.rustcTarget}"
  ];

  # mirror Cargo flags
  cargoCBuildFlags =
    optionals (finalAttrs.cargoBuildType != "debug") [
      "--profile=${finalAttrs.cargoBuildType}"
    ]
    ++ optionals (finalAttrs.cargoBuildNoDefaultFeatures) [
      "--no-default-features"
    ]
    ++ optionals (finalAttrs.cargoBuildFeatures != [ ]) [
      "--features=${concatStringsSep "," finalAttrs.cargoBuildFeatures}"
    ];

  cargoCTestFlags =
    optionals (finalAttrs.cargoCheckType != "debug") [
      "--profile=${finalAttrs.cargoCheckType}"
    ]
    ++ optionals (finalAttrs.cargoCheckNoDefaultFeatures) [
      "--no-default-features"
    ]
    ++ optionals (finalAttrs.cargoCheckFeatures != [ ]) [
      "--features=${concatStringsSep "," finalAttrs.cargoCheckFeatures}"
    ];

  configurePhase = ''
    runHook preConfigure

    # let stdenv handle stripping
    export "CARGO_PROFILE_''${cargoBuildType@U}_STRIP"=false

    prependToVar cargoCFlags -j "$NIX_BUILD_CORES"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    ${setEnv} cargo cbuild "''${cargoCFlags[@]}" "''${cargoCBuildFlags[@]}"

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ${setEnv} cargo ctest "''${cargoCFlags[@]}" "''${cargoCTestFlags[@]}"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    ${setEnv} cargo cinstall "''${cargoCFlags[@]}" "''${cargoCBuildFlags[@]}"

    runHook postInstall
  '';

  passthru.tests = {
    inherit hdr10plus_tool;
  };

  meta = {
    description = "Library to work with HDR10+ in HEVC files";
    homepage = "https://github.com/quietvoid/hdr10plus_tool";
    changelog = "https://github.com/quietvoid/hdr10plus_tool/releases/tag/${hdr10plus_tool.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    pkgConfigModules = [ "hdr10plus-rs" ];
  };
})
