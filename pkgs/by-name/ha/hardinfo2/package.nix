{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
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
  wrapGAppsHook,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "hardinfo2";
  version = "2.1.11";

  src = fetchFromGitHub {
    owner = "hardinfo2";
    repo = "hardinfo2";
    rev = "refs/tags/release-${version}";
    hash = "sha256-y6Lj1uDFDfg3X2IsmWja+Gr2KgKQQHNTCEnGWqJeG7Q=";
  };

  patches = [ ./dont-use-etc-os-release-file.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
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
    wrapGAppsHook
    xorg.libXdmcp
    xorg.libXtst
  ];

  hardeningDisable = [ "fortify" ];

  cmakeFlags = [ (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share") ];

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
