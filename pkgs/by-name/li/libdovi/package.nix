{
  lib,
  stdenv,
  rust,
  rustPlatform,
  dovi-tool,
  cargo-c,
}:

let
  inherit (rust.envVars) setEnv;
  inherit (lib) optionals concatStringsSep;
in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "libdovi";
  version = "3.3.1";

  outputs = [
    "out"
    "dev"
  ];

  inherit (dovi-tool)
    src
    useFetchCargoVendor
    cargoDeps
    cargoHash
    ;

  nativeBuildInputs = [ cargo-c ];

  cargoCFlags = [
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

  cargoRoot = "dolby_vision";

  configurePhase = ''
    # let stdenv handle stripping
    export "CARGO_PROFILE_''${cargoBuildType@U}_STRIP"=false
    prependToVar cargoCFlags -j "$NIX_BUILD_CORES"
  '';

  buildPhase = ''
    runHook preBuild
    ${setEnv} cargo cbuild "''${cargoCFlags[@]}" "''${cargoCBuildFlags[@]}"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${setEnv} cargo ctest "''${cargoCFlags[@]}" "''${cargoCTestFlags[@]}"
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ${setEnv} cargo cinstall "''${cargoCFlags[@]}" "''${cargoCBuildFlags[@]}"
    runHook postCheck
  '';

  passthru.tests = {
    inherit dovi-tool;
  };

  meta = {
    description = "C library for Dolby Vision metadata parsing and writing";
    homepage = "https://crates.io/crates/dolby_vision";
    changelog = "https://github.com/quietvoid/hdr10plus_tool/releases/tag/${dovi-tool.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kranzes ];
    pkgConfigModules = [ "dovi" ];
  };
})
