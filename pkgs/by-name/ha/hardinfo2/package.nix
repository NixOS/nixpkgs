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

stdenv.mkDerivation (finalAtrs: {
  pname = "hardinfo2";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "hardinfo2";
    repo = "hardinfo2";
    rev = "refs/tags/release-${finalAtrs.version}";
    hash = "sha256-UgVryuUkD9o2SvwA9VbX/kCaAo3+Osf6FxlYyaRX1Ag=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
    libsForQt5.wrapQtAppsHook
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  dontWrapQtApps = true;

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
    description = "System information and benchmarks for Linux systems";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
    mainProgram = "hardinfo";
  };
})
