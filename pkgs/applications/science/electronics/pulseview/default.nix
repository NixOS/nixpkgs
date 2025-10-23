{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "0.4.2-unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "sigrokproject";
    repo = "pulseview";
    rev = "e2fe9dfb91c7de85c410922ee9268c3f526bcc54";
    hash = "sha256-b9pqtsF5J9MA7XMIgFZltrVqi64ZPObBTiaws3zSDRg=";
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
