{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  writeShellApplication,
  nix,
  gnugrep,
}:

let
  # The x86-64-modern may need to be refined further in the future
  # but stdenv.hostPlatform CPU flags do not currently work on Darwin
  # https://discourse.nixos.org/t/darwin-system-and-stdenv-hostplatform-features/9745
  archDarwin = if stdenv.hostPlatform.isx86_64 then "x86-64-modern" else "apple-silicon";
  arch =
    if stdenv.hostPlatform.isDarwin then
      archDarwin
    else if stdenv.hostPlatform.isx86_64 then
      "x86-64"
    else if stdenv.hostPlatform.isi686 then
      "x86-32"
    else if stdenv.hostPlatform.isAarch64 then
      "armv8"
    else
      "unknown";

  # These files can be found in src/evaluate.h
  nnueBigFile = "nn-c288c895ea92.nnue";
  nnueBigHash = "sha256-wojIleqSRCnqkJLj82srPB8A8qOkx1n/flfnnjtD5Kc=";
  nnueBig = fetchurl {
    name = nnueBigFile;
    url = "https://tests.stockfishchess.org/api/nn/${nnueBigFile}";
    hash = nnueBigHash;
  };
  nnueSmallFile = "nn-37f18f62d772.nnue";
  nnueSmallHash = "sha256-N/GPYtdy8xB+HWqso4mMEww8hvKrY+ZVX7vKIGNaiZ0=";
  nnueSmall = fetchurl {
    name = nnueSmallFile;
    url = "https://tests.stockfishchess.org/api/nn/${nnueSmallFile}";
    hash = nnueSmallHash;
  };
in

stdenv.mkDerivation rec {
  pname = "stockfish";
  version = "18";

  src = fetchFromGitHub {
    owner = "official-stockfish";
    repo = "Stockfish";
    tag = "sf_${version}";
    hash = "sha256-J9E0fJeUemKh1mAPJ5PjZ3kmXqAc1Ec3dG5sfzvhuGo=";
  };

  postUnpack = ''
    sourceRoot+=/src
    cp "${nnueBig}" "$sourceRoot/${nnueBigFile}"
    cp "${nnueSmall}" "$sourceRoot/${nnueSmallFile}"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ARCH=${arch}"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];
  buildFlags = [ "build" ];

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/stockfish";
  versionCheckProgramArg = "--help";

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [ "--version-regex=^sf_([\\d.]+)$" ];
      })
      (lib.getExe (writeShellApplication {
        name = "${pname}-nnue-updater";
        runtimeInputs = [
          nix
          gnugrep
        ];
        runtimeEnv = {
          PNAME = pname;
          PKG_FILE = toString ./package.nix;
          NNUE_BIG_FILE = nnueBigFile;
          NNUE_BIG_HASH = nnueBigHash;
          NNUE_SMALL_FILE = nnueSmallFile;
          NNUE_SMALL_HASH = nnueSmallHash;
        };
        text = builtins.readFile ./update.bash;
      }))
    ];
  };

  meta = {
    homepage = "https://stockfishchess.org/";
    description = "Strong open source chess engine";
    mainProgram = "stockfish";
    longDescription = ''
      Stockfish is one of the strongest chess engines in the world. It is also
      much stronger than the best human chess grandmasters.
    '';
    maintainers = with lib.maintainers; [
      luispedro
      siraben
      thibaultd
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    license = lib.licenses.gpl3Only;
  };

}
