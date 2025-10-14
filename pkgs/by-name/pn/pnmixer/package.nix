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
    rev = "v${finalAttrs.version}";
    sha256 = "0416pa933ddf4b7ph9zxhk5jppkk7ppcq1aqph6xsrfnka4yb148";
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
