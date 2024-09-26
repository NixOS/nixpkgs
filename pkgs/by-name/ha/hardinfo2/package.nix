{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  libsForQt5,
  wrapGAppsHook4,

  gtk3,
  json-glib,
  lerc,
  libdatrie,
  libepoxy,
  libnghttp2,
  libpsl,
  libselinux,
  libsepol,
  libsoup_3,
  libsysprof-capture,
  libthai,
  libxkbcommon,
  pcre2,
  sqlite,
  util-linux,
  libXdmcp,
  libXtst,
}:

stdenv.mkDerivation {
  pname = "hardinfo2";
  version = "2.1.12-unstable-2024-2024-08-23";

  src = fetchFromGitHub {
    owner = "hardinfo2";
    repo = "hardinfo2";
    rev = "260d4c58520ec38743b8ce6554c89cf622227e90"; # features fixes for nixos
    hash = "sha256-r29+r3KWvbdlzP3zVa/AcKT3WavanJvMtQmRDUMDVkU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    gtk3
    json-glib
    lerc
    libdatrie
    libepoxy
    libnghttp2
    libpsl
    libselinux
    libsepol
    libsoup_3
    libsysprof-capture
    libthai
    libxkbcommon
    pcre2
    sqlite
    util-linux
    libXdmcp
    libXtst
  ];

  hardeningDisable = [ "fortify" ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
    (lib.cmakeFeature "CMAKE_INSTALL_SERVICEDIR" "${placeholder "out"}/lib")
  ];

  meta = {
    homepage = "http://www.hardinfo2.org";
    description = "System Information and Benchmark for Linux Systems ";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    mainProgram = "hardinfo";
  };
}
