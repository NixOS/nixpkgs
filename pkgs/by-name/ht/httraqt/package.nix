{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  httrack,
  libsForQt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httraqt";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://sourceforge/httraqt/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "0pjxqnqchpbla4xiq4rklc06484n46cpahnjy03n9rghwwcad25b";
  };

  buildInputs = [
    httrack
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6 FATAL_ERROR)" \
        "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)" \
      --replace-fail "CMAKE_POLICY(SET CMP0003 OLD)" "" \
      --replace-fail "CMAKE_POLICY(SET CMP0015 OLD)" ""

    substituteInPlace cmake/HTTRAQTFindHttrack.cmake \
      --replace-fail /usr/include/httrack/ ${httrack}/include/httrack/

    substituteInPlace distribution/posix/CMakeLists.txt \
      --replace-fail /usr/share $out/share

    substituteInPlace desktop/httraqt.desktop \
      --replace-fail Exec=httraqt Exec=$out/bin/httraqt

    substituteInPlace sources/main/httraqt.cpp \
      --replace-fail /usr/share/httraqt/ $out/share/httraqt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Easy-to-use offline browser / website mirroring utility - QT frontend";
    mainProgram = "httraqt";
    homepage = "https://httraqt.sourceforge.net";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
