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
  nnueBigFile = "nn-9a0cc2a62c52.nnue";
  nnueBigHash = "sha256-mgzCpixSClN6rTrG6QiowJiqkAidyny8h0zCGXYYvyM=";
  nnueBig = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueBigFile}";
    hash = nnueBigHash;
  };
  nnueSmallFile = "nn-47fc8b7fff06.nnue";
  nnueSmallHash = "sha256-R/yLf/8GfSQEdJO4TkKrhVwPzrUFjAFsafjuXE7kvWk=";
  nnueSmall = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueSmallFile}";
    hash = nnueSmallHash;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fishnet";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = "fishnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ArTovfr9znjudo53W5hnnSZlzfEnAd7E+7DXTqtN6w=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnueBig}' 'Stockfish/src/${nnueBigFile}'
    cp -v '${nnueBig}' 'Fairy-Stockfish/src/${nnueBigFile}'
    cp -v '${nnueSmall}' 'Stockfish/src/${nnueSmallFile}'
    cp -v '${nnueSmall}' 'Fairy-Stockfish/src/${nnueSmallFile}'
  '';

  cargoHash = "sha256-mkioBmawYR5GvR0WSlaicGyXV4EVVVQuai5UF5+Thk8=";

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
