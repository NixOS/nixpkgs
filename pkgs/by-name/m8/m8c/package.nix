{
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  SDL2,
  libserialport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m8c";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "laamaa";
    repo = "m8c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ijPRh/aurquh5JFngtoIBniopfVC67lL2X0M7AxT4SU=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL2
    libserialport
  ];

  meta = {
    description = "Cross-platform M8 tracker headless client";
    homepage = "https://github.com/laamaa/m8c";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrtnvgr ];
    mainProgram = "m8c";
  };
})
