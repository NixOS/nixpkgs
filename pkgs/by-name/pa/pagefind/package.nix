{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  binaryen,
  gzip,
  nodejs,
  npmHooks,
  python3,
  rustc,
  versionCheckHook,
  wasm-bindgen-cli_0_2_129,
  wasm-pack,
  enableExtended ? true,
}:

# TODO: package python bindings

rustPlatform.buildRustPackage (finalAttrs: {
  inherit enableExtended;

  pname = "pagefind" + lib.optionalString (finalAttrs.enableExtended) "-extended";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Pagefind";
    repo = "pagefind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWz77LVqC8VJqol9kxdsOdm3ZmmPh3PT8Ip7TjNl9e8=";
  };

  cargoPatches = [ ./cargo-lock.patch ]; # html-escape has the wrong version
  cargoHash = "sha256-9fhHc1/xDMAHdv7AquFr/qgzOajy6+SDUwZkty7i2zU=";

  env.cargoDeps_web = rustPlatform.fetchCargoVendor {
    name = "cargo-deps-web-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_web";
    hash = "sha256-Idw5aqP5z32HBpBcIQkJxEWY+K1I5Din4HjqbJNrBUY=";
  };
  env.npmDeps_web_js = fetchNpmDeps {
    name = "pagefind-npm-deps-web-js-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_web_js";
    hash = "sha256-WgpxfMpuFJlq4dqv5+eCbeZMInuKNQAnlvTndKbfPHA=";
  };
  env.npmDeps_ui_default = fetchNpmDeps {
    name = "pagefind-npm-deps-ui-default-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_ui/default";
    hash = "sha256-jteH1xgmw4IjHr1WWZrDgzkTHb8QRfE22gXnz3/NYv0=";
  };
  env.npmDeps_ui_modular = fetchNpmDeps {
    name = "pagefind-npm-deps-ui-modular-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_ui/modular";
    hash = "sha256-R6r/7bCBdW1la0TmJ6EUQ9qGz4TsbDaD+suiyTluoMI=";
  };
  env.npmDeps_ui_component = fetchNpmDeps {
    name = "pagefind-npm-deps-ui-component-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_ui/component";
    hash = "sha256-yc6ZZsg2NVX2lzrhWnouyVcH5j4Nyq3SRcBKnEjNlt0=";
  };
  env.npmDeps_playground = fetchNpmDeps {
    name = "pagefind-npm-deps-playground-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_playground";
    hash = "sha256-mHhMSoxNgIwFShooVVXRD9nz0RE11xpkHbBeI6rQ6Xw=";
  };

  env.GIT_VERSION = finalAttrs.version;

  postPatch = ''
    # Set the correct version, e.g. for `pagefind --version`
    node .backstage/version.cjs

    # Tricky way to run the cargo setup a second time
    (
      cd pagefind_web
      cargoDeps=$cargoDeps_web cargoSetupPostUnpackHook
      cargoDeps=$cargoDeps_web cargoSetupPostPatchHook
    )

    # Tricky way to run npmConfigHook multiple times
    (
      local postPatchHooks=() # written to by npmConfigHook
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=pagefind_web_js       npmDeps=$npmDeps_web_js       npmConfigHook
      npmRoot=pagefind_ui/default   npmDeps=$npmDeps_ui_default   npmConfigHook
      npmRoot=pagefind_ui/modular   npmDeps=$npmDeps_ui_modular   npmConfigHook
      npmRoot=pagefind_ui/component npmDeps=$npmDeps_ui_component npmConfigHook
      npmRoot=pagefind_playground   npmDeps=$npmDeps_playground   npmConfigHook
    )

    # nightly-only features
    substituteInPlace pagefind_web/local_build.sh \
      --replace-fail 'RUSTFLAGS="-Z unstable-options -C panic=immediate-abort"' 'RUSTFLAGS=""' \
      --replace-fail ' -Z build-std=panic_abort,std' ""
    substituteInPlace pagefind_web/local_fast_build.sh \
      --replace-fail ' -Z build-std=panic_abort,std' "" \
      --replace-fail ' -Z build-std-features=panic_immediate_abort' ""
  '';

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    binaryen
    gzip
    nodejs
    rustc
    rustc.llvmPackages.lld
    wasm-bindgen-cli_0_2_129
    wasm-pack
  ]
  ++ lib.optionals stdenv.buildPlatform.isDarwin [
    python3
  ];

  # build wasm and js assets
  # based on "test-and-build" in https://github.com/CloudCannon/pagefind/blob/main/.github/workflows/release.yml
  preBuild = ''
    export HOME=$(mktemp -d)

    echo Entering ./pagefind_web_js
    (
      cd pagefind_web_js
      npm run build-coupled
    )

    echo Entering ./pagefind_web
    (
      cd pagefind_web
      bash ./local_build.sh
    )

    echo Entering ./pagefind_ui/default
    (
      cd pagefind_ui/default
      npm run build
    )

    echo Entering ./pagefind_ui/modular
    (
      cd pagefind_ui/modular
      npm run build
    )

    echo Entering ./pagefind_ui/component
    (
      cd pagefind_ui/component
      npm run build
    )

    echo Entering ./pagefind_playground
    (
      cd pagefind_playground
      npm run build
    )
  '';

  buildFeatures = lib.optionals finalAttrs.enableExtended [ "extended" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    tests.extended = finalAttrs.finalPackage.overrideAttrs {
      enableExtended = true;
    };
    tests.non-extended = finalAttrs.finalPackage.overrideAttrs {
      enableExtended = false;
    };
  };

  meta = {
    description = "Generate low-bandwidth search index for your static website";
    homepage = "https://pagefind.app/";
    changelog = "https://github.com/Pagefind/pagefind/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.unix;
    mainProgram = "pagefind";
  };
})
