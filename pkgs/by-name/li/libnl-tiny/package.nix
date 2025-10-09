{
  stdenv,
  lib,
  fetchgit,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libnl-tiny";
  version = "0-unstable-2025-03-19";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libnl-tiny.git";
    rev = "c0df580adbd4d555ecc1962dbe88e91d75b67a4e";
    hash = "sha256-j5oIEbWqVWd7rNpCMm9+WZwud43uTGeHG81lmzQOoeY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  preConfigure = ''
    sed -e 's|''${prefix}/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_FULL_LIBDIR@|g' \
        -e 's|''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_FULL_INCLUDEDIR@|g' \
        -i libnl-tiny.pc.in
  '';

  meta = with lib; {
    description = "Tiny OpenWrt fork of libnl";
    homepage = "https://git.openwrt.org/?p=project/libnl-tiny.git;a=summary";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      mkg20001
      dvn0
    ];
    platforms = platforms.linux;
  };
}
