{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxdg-basedir";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "devnev";
    repo = "libxdg-basedir";
    tag = "libxdg-basedir-${finalAttrs.version}";
    hash = "sha256-ewtUKDdE6k9Q9hglWwhbTU3DTxvIN41t+zf2Gch9Dkk=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Implementation of the XDG Base Directory specification";
    homepage = "https://github.com/devnev/libxdg-basedir";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
    platforms = lib.platforms.unix;
  };
})
