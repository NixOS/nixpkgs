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
  nnueBigFile = "nn-1c0000000000.nnue";
  nnueBigHash = "sha256-HAAAAAAApn1imZnZMtDDc/dFDOQ80S0FYoaPTq+a4q0=";
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
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "fishnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BtOPLqfE6SjCr8/HS5oev1j3R26+wkWw051gZwDyCM0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnueBig}' 'Stockfish/src/${nnueBigFile}'
    cp -v '${nnueBig}' 'Fairy-Stockfish/src/${nnueBigFile}'
    cp -v '${nnueSmall}' 'Stockfish/src/${nnueSmallFile}'
    cp -v '${nnueSmall}' 'Fairy-Stockfish/src/${nnueSmallFile}'
  '';

  cargoHash = "sha256-1Pk9vXo1ivE8H6ctS8PEsCEv/EKFxFtgnmrvik6Gwug=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";

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
        PKG_FILE = builtins.toString ./package.nix;
        GITHUB_REPOSITORY = "${finalAttrs.src.owner}/${finalAttrs.src.repo}";
        NNUE_BIG_FILE = nnueBigFile;
        NNUE_BIG_HASH = nnueBigHash;
        NNUE_SMALL_FILE = nnueSmallFile;
        NNUE_SMALL_HASH = nnueSmallHash;
      };

      text = builtins.readFile ./update.bash;
    });
  };

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/lichess-org/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
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
