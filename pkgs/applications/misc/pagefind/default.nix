{ lib
, callPackage
, rustPlatform
, fetchFromGitHub
, fetchNpmDeps
, npmHooks
, binaryen
, gzip
, nodejs
, rustc-wasm32
, wasm-bindgen-cli
, wasm-pack
}:

let

  wasm-bindgen-84 = wasm-bindgen-cli.override {
    version = "0.2.84";
    hash = "sha256-0rK+Yx4/Jy44Fw5VwJ3tG243ZsyOIBBehYU54XP/JGk=";
    cargoHash = "sha256-vcpxcRlW1OKoD64owFF6mkxSqmNrvY+y3Ckn5UwEQ50=";
  };

in

rustPlatform.buildRustPackage rec {
  pname = "pagefind";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "cloudcannon";
    repo = "pagefind";
    rev = "refs/tags/v${version}";
    hash = "sha256-IN+l5Wq89tjppE0xCcvczQSkJc1CLymEFeieJhvQQ54=";
  };

  cargoHash = "sha256-T7DBuqfpqaEmu9iItnFYsJVnEFxG1r9uXEkfqJp1mD8=";

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

  postPatch = ''
    # Tricky way to run npmConfigHook multiple times
    (
      local postPatchHooks=() # written to by npmConfigHook
      source ${npmHooks.npmConfigHook}/nix-support/setup-hook
      npmRoot=pagefind_web_js     npmDeps=$npmDeps_web_js     npmConfigHook
      npmRoot=pagefind_ui/default npmDeps=$npmDeps_ui_default npmConfigHook
      npmRoot=pagefind_ui/modular npmDeps=$npmDeps_ui_modular npmConfigHook
    )
  '';

  nativeBuildInputs = [
    binaryen
    gzip
    nodejs
    rustc-wasm32
    rustc-wasm32.llvmPackages.lld
    wasm-bindgen-84
    wasm-pack
  ];

  # build wasm and js assets
  # based on "test-and-build" in https://github.com/CloudCannon/pagefind/blob/main/.github/workflows/release.yml
  preBuild = ''
    export HOME=$(mktemp -d)
    (
      cd pagefind_web_js
      npm run build-coupled
    )

    (
      cd pagefind_web
      export RUSTFLAGS="-C linker=lld"
      bash ./local_build.sh
    )

    (
      cd pagefind_ui/default
      npm run build
    )

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
  };
}
