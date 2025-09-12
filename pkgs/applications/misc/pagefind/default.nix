{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  binaryen,
  gzip,
  nodejs,
  npmHooks,
  python3,
  rustc,
  versionCheckHook,
  wasm-bindgen-cli_0_2_92,
  wasm-pack,
}:

# TODO: package python bindings

let

  # the lindera-unidic v0.32.2 crate uses [1] an outdated unidic-mecab fork [2] and builds it in pure rust
  # [1] https://github.com/lindera/lindera/blob/v0.32.2/lindera-unidic/build.rs#L5-L11
  # [2] https://github.com/lindera/unidic-mecab
  # To find these urls:
  #   rg -A5 download_urls $(nix-build . -A pagefind.cargoDeps --no-out-link)/lindera-*/build.rs
  lindera-srcs = {
    unidic-mecab = fetchurl {
      passthru.vendorDir = "lindera-unidic-*";
      url = "https://Lindera.dev/unidic-mecab-2.1.2.tar.gz";
      hash = "sha256-JKx1/k5E2XO1XmWEfDX6Suwtt6QaB7ScoSUUbbn8EYk=";
    };
    mecab-ko-dic = fetchurl {
      passthru.vendorDir = "lindera-ko-dic-*";
      url = "https://Lindera.dev/mecab-ko-dic-2.1.1-20180720.tar.gz";
      hash = "sha256-cCztIcYWfp2a68Z0q17lSvWNREOXXylA030FZ8AgWRo=";
    };
    ipadic = fetchurl {
      passthru.vendorDir = "lindera-ipadic-0.*";
      url = "https://Lindera.dev/mecab-ipadic-2.7.0-20070801.tar.gz";
      hash = "sha256-CZ5G6A1V58DWkGeDr/cTdI4a6Q9Gxe+W7BU7vwm/VVA=";
    };
    cc-cedict = fetchurl {
      passthru.vendorDir = "lindera-cc-cedict-*";
      url = "https://lindera.dev/CC-CEDICT-MeCab-0.1.0-20200409.tar.gz";
      hash = "sha256-7Tz54+yKgGR/DseD3Ana1DuMytLplPXqtv8TpB0JFsg=";
    };
    ipadic-neologd = fetchurl {
      passthru.vendorDir = "lindera-ipadic-neologd-*";
      url = "https://lindera.dev/mecab-ipadic-neologd-0.0.7-20200820.tar.gz";
      hash = "sha256-1VwCwgSTKFixeQUFVCdqMzZKne/+FTgM56xT7etqjqI=";
    };
  };

in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pagefind";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Pagefind";
    repo = "pagefind";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+jArZueDqpJQKg3fKdJjeQQL+egyR6Zi6wqPMZoFgyk=";
  };

  cargoPatches = [ ./cargo-lock.patch ];
  cargoHash = "sha256-zbo8NkB9umpNDvkhKXpOdt8hJn+d+nrTXMaUghmIPrg=";

  env.cargoDeps_web = rustPlatform.fetchCargoVendor {
    name = "cargo-deps-web-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_web";
    hash = "sha256-DaipINtwePA03YdbSzh6EjH4Q13P3CB9lwcmTOR54dM=";
  };
  env.npmDeps_web_js = fetchNpmDeps {
    name = "pagefind-npm-deps-web-js-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_web_js";
    hash = "sha256-whpmjNKdiMxNfg7fRIWUPdyRWqsEphhqvQfiM65GYDs=";
  };
  env.npmDeps_ui_default = fetchNpmDeps {
    name = "pagefind-npm-deps-ui-default-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_ui/default";
    hash = "sha256-voCs49JneWYE1W9U7aB6G13ypH6JqathVDeF58V57U8=";
  };
  env.npmDeps_ui_modular = fetchNpmDeps {
    name = "pagefind-npm-deps-ui-modular-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_ui/modular";
    hash = "sha256-4d85V2X1doq3G8okgYSXOMuQDoAXCgtAtegFEPr+Wno=";
  };
  env.npmDeps_playground = fetchNpmDeps {
    name = "pagefind-npm-deps-playground-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/pagefind_playground";
    hash = "sha256-npo8MV6AAuQ/mGC9iu3bR7pjGoI7NgxuIeh+H3oz7Y8=";
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
      npmRoot=pagefind_web_js     npmDeps=$npmDeps_web_js     npmConfigHook
      npmRoot=pagefind_ui/default npmDeps=$npmDeps_ui_default npmConfigHook
      npmRoot=pagefind_ui/modular npmDeps=$npmDeps_ui_modular npmConfigHook
      npmRoot=pagefind_playground npmDeps=$npmDeps_playground npmConfigHook
    )

    # patch build-time dependency downloads
    (
      # add support for file:// urls
      patch -d $cargoDepsCopy/lindera-dictionary-*/ -p1 < ${./lindera-dictionary-support-file-paths.patch}

      # patch urls
      ${lib.pipe finalAttrs.passthru.lindera-srcs [
        (lib.mapAttrsToList (
          key: src: ''
            # compgen is only in bashInteractive
            declare -a expanded_glob=($cargoDepsCopy/${src.vendorDir}/build.rs)
            if [[ "''${#expanded_glob[@]}" -eq 0 ]]; then
              echo >&2 "ERROR: '$cargoDepsCopy/${src.vendorDir}/build.rs' not found! (pagefind.passthru.lindera-srcs.${key})"
              false
            elif [[ "''${#expanded_glob[@]}" -gt 1 ]]; then
              echo >&2 "ERROR: '$cargoDepsCopy/${src.vendorDir}/build.rs' matches more than one file! (pagefind.passthru.lindera-srcs.${key})"
              printf >&2 "match: %s\n" "''${expanded_glob[@]}"
              false
            fi
            echo "patching $cargoDepsCopy/${src.vendorDir}/build.rs..."
            substituteInPlace $cargoDepsCopy/${src.vendorDir}/build.rs --replace-fail "${src.url}" "file://${src}"
            unset expanded_glob
          ''
        ))
        lib.concatLines
      ]}
    )

    # nightly-only feature
    substituteInPlace pagefind_web/local_build.sh \
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
    wasm-bindgen-cli_0_2_92
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

    echo Entering ./pagefind_playground
    (
      cd pagefind_playground
      npm run build
    )
  '';

  # always build extended
  buildFeatures = [ "extended" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    inherit lindera-srcs;
    tests.non-extended = finalAttrs.finalPackage.overrideAttrs {
      buildFeatures = [ ];
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
