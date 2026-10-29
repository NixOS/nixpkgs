{
  stdenv,
  lib,
  fetchurl,
  cmake,
  pkg-config,
  httrack,
  qt6Packages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httraqt";
  version = "1.4.11";

  src = fetchurl {
    url = "mirror://sourceforge/httraqt/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HfnUlJifpzWiP1rb+Kn3I/H6nYBeEB6cXVI5pu28K5E=";
  };

  buildInputs = [
    httrack
    qt6Packages.qtbase
    qt6Packages.qtmultimedia
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.8 FATAL_ERROR)" \
        "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)" \
      --replace-fail "CMAKE_POLICY(SET CMP0003 OLD)" "" \
      --replace-fail "CMAKE_POLICY(SET CMP0015 OLD)" ""

    substituteInPlace cmake/FindHttrack.cmake \
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
