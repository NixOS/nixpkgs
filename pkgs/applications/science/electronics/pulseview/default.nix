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
  version = "0.5.0-unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "sigrokproject";
    repo = "pulseview";
    rev = "af02198741b4e57c9f9b796bd5e6c0f2ae9f2f2b";
    hash = "sha256-4K3sMCTlFnu8iiokMYc1O7jNVQ7vTtSiT2dCpLRC44s=";
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

  meta = {
    description = "Qt-based LA/scope/MSO GUI for sigrok (a signal analysis software suite)";
    mainProgram = "pulseview";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      bjornfor
      vifino
    ];
    platforms = lib.platforms.unix;
  };
}
