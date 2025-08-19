{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  cmake,
  glib,
  boost,
  libsigrok,
  libsigrokdecode,
  libserialport,
  libzip,
  libftdi1,
  hidapi,
  glibmm,
  pcre,
  python3,
  qtsvg,
  qttools,
  bluez,
  wrapQtAppsHook,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation {
  pname = "pulseview";
  version = "0.4.2-unstable-2024-03-14";

  src = fetchgit {
    url = "git://sigrok.org/pulseview";
    rev = "d00efc65ef47090b71c4da12797056033bee795f";
    hash = "sha256-MwfMUqV3ejxesg+3cFeXVB5hwg4r0cOCgHJuH3ZLmNE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs = [
    glib
    boost
    libsigrok
    libsigrokdecode
    libserialport
    libzip
    libftdi1
    hidapi
    glibmm
    pcre
    python3
    qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ bluez ];

  meta = with lib; {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    mainProgram = "pulseview";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      bjornfor
      vifino
    ];
    platforms = platforms.unix;
  };
}
