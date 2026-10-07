{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  util-macros,
  xorgproto,
  libx11,
  libxext,
  xorg-server,
}:

stdenv.mkDerivation {
  pname = "xf86-video-nested";
  version = "0-unstable-2024-10-26";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-nested";
    rev = "03dab66493622835a29b873cd63df489f1a96ed9";
    hash = "sha256-EPQOcE23m6RSG05txjBjREBz9JlwZrmK4Rn6Fg2IyT4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];

  buildInputs = [
    xorg-server
    xorgproto
    libx11
    libxext
  ];

  meta = {
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-nested";
    description = "Video ddriver to run Xorg on top of another X server";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
