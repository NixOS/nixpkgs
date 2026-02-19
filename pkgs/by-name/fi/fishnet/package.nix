{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  versionCheckHook,
  writeShellApplication,
  curl,
  jq,
  nix-update,
  common-updater-scripts,
}:

let
  # These files can be found in Stockfish/src/evaluate.h
  nnueBigFile = "nn-c288c895ea92.nnue";
  nnueBigHash = "sha256-wojIleqSRCnqkJLj82srPB8A8qOkx1n/flfnnjtD5Kc=";
  nnueBig = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueBigFile}";
    hash = nnueBigHash;
  };
  nnueSmallFile = "nn-37f18f62d772.nnue";
  nnueSmallHash = "sha256-N/GPYtdy8xB+HWqso4mMEww8hvKrY+ZVX7vKIGNaiZ0=";
  nnueSmall = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueSmallFile}";
    hash = nnueSmallHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fishnet";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "fishnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SW51EQvh73ZnMX6MflEzL06a4+XnqPPs7ooaTqY9eVc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnueBig}' 'Stockfish/src/${nnueBigFile}'
    cp -v '${nnueBig}' 'Fairy-Stockfish/src/${nnueBigFile}'
    cp -v '${nnueSmall}' 'Stockfish/src/${nnueSmallFile}'
    cp -v '${nnueSmall}' 'Fairy-Stockfish/src/${nnueSmallFile}'
  '';

  cargoHash = "sha256-NzjgYS9AVQcKzI86Y3RPs2keqnby/LN5KGd6j4IesDQ=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-${finalAttrs.pname}";

      runtimeInputs = [
        curl
        jq
        nix-update
        common-updater-scripts
      ];

      runtimeEnv = {
        PNAME = finalAttrs.pname;
        PKG_FILE = toString ./package.nix;
        GITHUB_REPOSITORY = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
        NNUE_BIG_FILE = nnueBigFile;
        NNUE_BIG_HASH = nnueBigHash;
        NNUE_SMALL_FILE = nnueSmallFile;
        NNUE_SMALL_HASH = nnueSmallHash;
      };

      text = builtins.readFile ./update.bash;
    });
  };

  meta = {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/lichess-org/fishnet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      tu-maurice
      thibaultd
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "fishnet";
  };
})
