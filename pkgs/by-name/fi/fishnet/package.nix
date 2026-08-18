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
  # This file can be found in Stockfish/src/evaluate.h
  nnueFile = "nn-89cb98a217f7.nnue";
  nnueHash = "sha256-icuYohf3IBR8coYXYQl76koEKJl90iDsioGlYkMbu+Y=";
  nnue = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    hash = nnueHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fishnet";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "fishnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p6gZEQfC/XX0qp7nJZps5FNDea5iOVXN4hQ6f5nGKCc=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
    cp -v '${nnue}' 'Fairy-Stockfish/src/${nnueFile}'
  '';

  cargoHash = "sha256-S3mgeYujRLvEoJYLG8Np1f1JYuftF3lZlptG33QqbNM=";

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
        NNUE_FILE = nnueFile;
        NNUE_HASH = nnueHash;
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
