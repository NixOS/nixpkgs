{
  lib,
  stdenv,
  bash,
  bc,
  coreutils,
  fetchFromGitHub,
  gnugrep,
  makeWrapper,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash2048";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JosefZIla";
    repo = "bash2048";
    tag = finalAttrs.version;
    hash = "sha256-iSNW+S6e3HZc1b3xiyVNfBwwjrTI1riD5MYQLrok4q0=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bash2048.sh $out/bin/bash2048

    wrapProgram $out/bin/bash2048 \
      --set PATH ${
        lib.makeBinPath [
          bc
          coreutils
          gnugrep
          ncurses
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Bash implementation of 2048 game";
    homepage = "https://github.com/JosefZIla/bash2048";
    license = lib.licenses.unlicense;
    mainProgram = "bash2048";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
