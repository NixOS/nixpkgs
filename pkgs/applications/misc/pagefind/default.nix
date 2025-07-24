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
  lindera-unidic-src = fetchurl {
    url = "https://dlwqk3ibdg1xh.cloudfront.net/unidic-mecab-2.1.2.tar.gz";
    hash = "sha256-JKx1/k5E2XO1XmWEfDX6Suwtt6QaB7ScoSUUbbn8EYk=";
  };

in

rustPlatform.buildRustPackage rec {
  pname = "pagefind";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cloudcannon";
    repo = "pagefind";
    tag = "v${version}";
    hash = "sha256-NIEiXwuy8zuUDxPsD4Hiq3x4cOG3VM+slfNIBSJU2Mk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e1JSK8RnBPGcAmgxJZ7DaYhMMaUqO412S9YvaqXll3E=";

  env.npmDeps_web_js = fetchNpmDeps {
    name = "npm-deps-web-js";
    src = "${src}/pagefind_web_js";
    hash = "sha256-1gdVBCxxLEGFihIxoSSgxw/tMyVgwe7HFG/JjEfYVnQ=";
  };
  env.npmDeps_ui_default = fetchNpmDeps {
    name = "npm-deps-ui-default";
    src = "${src}/pagefind_ui/default";
    hash = "sha256-voCs49JneWYE1W9U7aB6G13ypH6JqathVDeF58V57U8=";
  };
  env.npmDeps_ui_modular = fetchNpmDeps {
    name = "npm-deps-ui-modular";
    src = "${src}/pagefind_ui/modular";
    hash = "sha256-O0RqZUsRFtByxMQdwNGNcN38Rh+sDqqNo9YlBcrnsF4=";
  };
  env.cargoDeps_web = rustPlatform.fetchCargoVendor {
    name = "cargo-deps-web";
    src = "${src}/pagefind_web/";
    hash = "sha256-xFVMWX3q3za1w8v58Eysk6vclPd4qpCuQMjMcwwHoh0=";
  };

  env.GIT_VERSION = version;

  postPatch = ''
    # Set the correct version, e.g. for `pagefind --version`
    node .backstage/version.cjs

    # Tricky way to run npmConfigHook multiple times
    (
      local postPatchHooks=() # written to by npmConfigHook
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=pagefind_web_js     npmDeps=$npmDeps_web_js     npmConfigHook
      npmRoot=pagefind_ui/default npmDeps=$npmDeps_ui_default npmConfigHook
      npmRoot=pagefind_ui/modular npmDeps=$npmDeps_ui_modular npmConfigHook
    )
    (
      cd pagefind_web
      cargoDeps=$cargoDeps_web cargoSetupPostUnpackHook
      cargoDeps=$cargoDeps_web cargoSetupPostPatchHook
    )

    # patch a build-time dependency download
    (
      patch -d $cargoDepsCopy/lindera-assets-*/ -p1 < ${./lindera-assets-support-file-paths.patch}

      substituteInPlace $cargoDepsCopy/lindera-unidic-*/build.rs --replace-fail \
          "${lindera-unidic-src.url}" \
          "file://${lindera-unidic-src}"
    )
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

    echo entering pagefind_web_js...
    (
      cd pagefind_web_js
      npm run build-coupled
    )

    echo entering pagefind_web...
    (
      cd pagefind_web
      bash ./local_build.sh
    )

    echo entering pagefind_ui/default...
    (
      cd pagefind_ui/default
      npm run build
    )

    echo entering pagefind_ui/modular...
    (
      cd pagefind_ui/modular
      npm run build
    )
  '';

  buildFeatures = [ "extended" ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Generate low-bandwidth search index for your static website";
    homepage = "https://pagefind.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.unix;
    mainProgram = "pagefind";
  };
}
