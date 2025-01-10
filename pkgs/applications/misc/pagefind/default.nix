{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  httplz,
  binaryen,
  gzip,
  nodejs,
  npmHooks,
  python3,
  rustc,
  wasm-bindgen-cli,
  wasm-pack,
}:

# TODO: package python bindings

let

  wasm-bindgen-92 = wasm-bindgen-cli.override {
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
    cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
  };

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
    rev = "refs/tags/v${version}";
    hash = "sha256-NIEiXwuy8zuUDxPsD4Hiq3x4cOG3VM+slfNIBSJU2Mk=";
  };

  cargoHash = "sha256-dfE4pfArW9hTPi7LCC9l274dNd1r0RAh50cciUGnv58=";

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

    # patch a build-time dependency download
    (
      cd $cargoDepsCopy/lindera-unidic
      oldHash=$(sha256sum build.rs | cut -d " " -f 1)

      # serve lindera-unidic on localhost vacant port
      httplz_port="${
        if stdenv.buildPlatform.isDarwin then
          ''$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')''
        else
          "34567"
      }"
      mkdir .lindera-http-plz
      ln -s ${lindera-unidic-src} .lindera-http-plz/unidic-mecab-2.1.2.tar.gz
      httplz --port "$httplz_port" -- .lindera-http-plz/ &
      echo $! >$TMPDIR/.httplz_pid

      # file:// does not work
      substituteInPlace build.rs --replace-fail \
          "https://dlwqk3ibdg1xh.cloudfront.net/unidic-mecab-2.1.2.tar.gz" \
          "http://localhost:$httplz_port/unidic-mecab-2.1.2.tar.gz"

      newHash=$(sha256sum build.rs | cut -d " " -f 1)
      substituteInPlace .cargo-checksum.json --replace-fail $oldHash $newHash
    )
  '';

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs =
    [
      binaryen
      gzip
      nodejs
      rustc
      rustc.llvmPackages.lld
      wasm-bindgen-92
      wasm-pack
      httplz
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

  # the file is also fetched during checkPhase
  preInstall = ''
    kill ${lib.optionalString stdenv.hostPlatform.isDarwin "-9"} $(cat $TMPDIR/.httplz_pid)
  '';

  buildFeatures = [ "extended" ];

  meta = {
    description = "Generate low-bandwidth search index for your static website";
    homepage = "https://pagefind.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.unix;
    mainProgram = "pagefind";
  };
}
