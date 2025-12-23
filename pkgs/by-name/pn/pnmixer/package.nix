{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gettext,
  alsa-lib,
  gtk3,
  glib,
  libnotify,
  libX11,
  pcre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pnmixer";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "nicklan";
    repo = "pnmixer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iITliZrWZd0NvFgFzO49c94ry4T9J3jPIq61MZK6JhA=";
  };

  patches = [
    # https://github.com/nicklan/pnmixer/pull/197
    ./fix-cmake-version.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
  ];

  buildInputs = [
    alsa-lib
    gtk3
    glib
    libnotify
    libX11
    pcre
  ];

  meta = {
    homepage = "https://github.com/nicklan/pnmixer";
    description = "ALSA volume mixer for the system tray";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      campadrenalin
      romildo
    ];
    mainProgram = "pnmixer";
  };
})
