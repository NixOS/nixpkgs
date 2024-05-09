{ lib
, callPackage
, rustPlatform
, fetchFromGitHub
, fetchNpmDeps
, npmHooks
, binaryen
, gzip
, nodejs
, rustc
, wasm-bindgen-cli
, wasm-pack
}:

let

  wasm-bindgen-92 = wasm-bindgen-cli.override {
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
    cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
  };

in

rustPlatform.buildRustPackage rec {
  pname = "pagefind";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "cloudcannon";
    repo = "pagefind";
    rev = "refs/tags/v${version}";
    hash = "sha256-pcgcu9zylSTjj5rxNff+afFBWVpN5sGtlpadG1wb93M=";
  };

  cargoHash = "sha256-E4gjG5GrVWkMKgjQiAvEiSy2/tx/yHKe+5isveMZ9tU=";

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
  env.cargoDeps_web = rustPlatform.fetchCargoTarball {
    name = "cargo-deps-web";
    src = "${src}/pagefind_web/";
    hash = "sha256-vDkVXyDePKgYTYE5ZTLLfOHwPYfgaqP9p5/fKCQQi0g=";
  };

  postPatch = ''
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
  '';

  nativeBuildInputs = [
    binaryen
    gzip
    nodejs
    rustc
    rustc.llvmPackages.lld
    wasm-bindgen-92
    wasm-pack
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
      export RUSTFLAGS="-C linker=lld"
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

  meta = with lib; {
    description = "Generate low-bandwidth search index for your static website";
    homepage = "https://pagefind.app/";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
    platforms = platforms.unix;
    mainProgram = "pagefind";
  };
}
