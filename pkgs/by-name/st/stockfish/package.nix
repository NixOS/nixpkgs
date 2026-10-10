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
    else if stdenv.hostPlatform.isAarch32 then
      "armv7"
    else
      "unknown";

  # This file can be found in src/evaluate.h
  nnueFile = "nn-1a298aa575a0.nnue";
  nnueHash = "sha256-GimKpXWghUNNKQJ5eNw2hn/pxbzqk3ZlS3qOuh5S38I=";
  nnue = fetchurl {
    name = nnueFile;
    url = "https://tests.stockfishchess.org/api/nn/${nnueFile}";
    hash = nnueHash;
  };
in

stdenv.mkDerivation rec {
  pname = "stockfish";
  version = "19";

  src = fetchFromGitHub {
    owner = "official-stockfish";
    repo = "Stockfish";
    tag = "sf_${version}";
    hash = "sha256-4sRJb8zYhbkuIsI6pOcfH6ZIotXBp7k1kHlxL8jk3vQ=";
  };

  postUnpack = ''
    sourceRoot+=/src
    cp "${nnue}" "$sourceRoot/${nnueFile}"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ARCH=${arch}"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "STRIP=${stdenv.cc.targetPrefix}strip"
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
          NNUE_FILE = nnueFile;
          NNUE_HASH = nnueHash;
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
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
    ];
    license = lib.licenses.gpl3Only;
  };

}
