{
  lib,
  fetchFromGitHub,
  rustPlatform,
  buildNpmPackage,
  nix-update-script,
  writableTmpDirAsHomeHook,
  pkg-config,
  perl,
  wasm-pack,
  wasm-bindgen-cli_0_2_108,
  binaryen,
  lld,
}:
let
  version = "0.34.1";
  pname = "rauthy";

  src = fetchFromGitHub {
    owner = "sebadob";
    repo = "rauthy";
    tag = "v${version}";
    hash = "sha256-6Ddf8ukwEecxBp9hMbWS4odxrRGB/uIXWdTbIU3MAUM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-fXe4bQRLscUk7fdAQGwzwBVJIRs8+puWfTeAjby1MmE=";
  };

  # Wasm modules are needed to build the frontend and are part of the main Rust repo.
  #
  # We use rustPlatform.buildRustPackage to get the correct environment for wasm-pack.
  # Since the "wasm-modules" crate has no binary output, cargoInstallPostBuildHook fails,
  # so we disable the cargo install phase.
  wasmModules = rustPlatform.buildRustPackage {
    inherit version src cargoDeps;
    pname = "${pname}-wasm-modules";

    nativeBuildInputs = [
      writableTmpDirAsHomeHook
      wasm-pack
      wasm-bindgen-cli_0_2_108
      binaryen
      lld
    ];

    buildPhase = ''
      runHook preBuild

      mkdir -p $out/wasm
      cd src/wasm-modules

      wasm-pack -v build --out-dir $out/wasm/spow --no-pack --out-name spow --features spow
      wasm-pack -v build --out-dir $out/wasm/md --no-pack --out-name md --features md

      runHook postBuild
    '';

    dontCargoInstall = true;

    # Skip checks here; they will run in the main package.
    doCheck = false;
  };

  frontend = buildNpmPackage {
    inherit version src;
    pname = "${pname}-frontend";

    sourceRoot = "${src.name}/frontend";

    patches = [
      ./0001-build-svelte-files-inside-the-current-directory.patch
    ];

    patchFlags = [
      "-p2"
    ];

    npmDepsHash = "sha256-F8/zbqI7Nmm8GLtkL25QDX222yzhlg7NA32tpBa8b5o=";

    preBuild = ''
      mkdir -p ./src/wasm/
      cp -r ${wasmModules}/wasm/* ./src/wasm/
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit
    pname
    version
    src
    cargoDeps
    ;

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  preBuild = ''
    cp -r ${frontend}/lib/node_modules/frontend/dist/templates/html/ templates/html
    cp -r ${frontend}/lib/node_modules/frontend/dist/static/ static
  '';

  # Tests fail and appear unmaintained upstream.
  doCheck = false;

  passthru = {
    inherit frontend;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=frontend"
      ];
    };
  };

  meta = {
    mainProgram = "rauthy";
    description = "Single Sign-On Identity & Access Management via OpenID Connect, OAuth 2.0 and PAM";
    homepage = "https://github.com/sebadob/rauthy";
    changelog = "https://github.com/sebadob/rauthy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
})
