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
  nnueFile = "nn-1a298aa575a0.nnue";
  nnueHash = "sha256-GimKpXWghUNNKQJ5eNw2hn/pxbzqk3ZlS3qOuh5S38I=";
  nnue = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    hash = nnueHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fishnet";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "fishnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QjIqv7J4h2ojFUp0LzN01zRwjavv3FMVgqSfQbp4/1I=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnue}' 'Stockfish/src/${nnueFile}'
    cp -v '${nnue}' 'Fairy-Stockfish/src/${nnueFile}'
  '';

  cargoHash = "sha256-JRiw6MkovadB3hNszHflFhKA5b9x/pz/grGEX9n+mpQ=";

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
