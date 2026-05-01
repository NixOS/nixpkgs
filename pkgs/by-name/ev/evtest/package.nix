{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evtest";
  version = "1.36";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libxml2 ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libevdev";
    repo = "evtest";
    tag = "evtest-${finalAttrs.version}";
    sha256 = "sha256-M7AGcHklErfRIOu64+OU397OFuqkAn4dqZxx7sDfklc=";
  };

  meta = {
    description = "Simple tool for input event debugging";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "evtest";
  };
})
