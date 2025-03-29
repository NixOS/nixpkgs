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
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "laamaa";
    repo = "m8c";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8QkvvTtFxQmDIqpyhZi/ORcB7YwENu+YafYtCZw0faE=";
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
