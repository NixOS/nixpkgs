{
  lib,
  stdenv,

  fetchFromGitHub,
  substitute,
  yarn-berry_4,

  cargo,
  cargo-tauri,
  cmake,
  nodejs-slim,
  pkg-config,
  rustc,
  rustPlatform,
  webkitgtk_4_1,

  cyrus_sasl,
  freetype,
  libsoup_3,
  openssl,
  curl,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "insulator2";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "andrewinci";
    repo = "insulator2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QCoDiFEgVuF/+MqgzcMTXqjC/nDA+A2v3l01kZyviDs=";

    # Remove after upstream updates to Yarn 4.15
    # https://github.com/andrewinci/insulator2/blob/main/package.json#L105
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-2w1fMVwQFClyrpNmJrjJoDqbU2nxRZh9NkBIcMUEjec=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = finalAttrs.src.name + "/backend";
    hash = "sha256-u5WFV7luvqSQQtEJFlN//GH6iNcQpH/o01ME1dPtOB4=";
  };

  cargoRoot = "backend/";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  strictDeps = true;

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo
    cargo-tauri.hook
    cmake
    nodejs-slim
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  buildInputs = [
    cyrus_sasl
    freetype
    libsoup_3
    openssl
    webkitgtk_4_1
    curl
  ];

  env.OPENSSL_NO_VENDOR = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client UI to inspect Kafka topics, consume, produce and much more";
    homepage = "https://github.com/andrewinci/insulator2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tc-kaluza ];
    mainProgram = "insulator2";
  };
})
