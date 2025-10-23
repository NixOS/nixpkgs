{
  stdenv,
  lib,
  fetchgit,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libnl-tiny";
  version = "0-unstable-2025-10-20";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libnl-tiny.git";
    rev = "c69fb5ef80b9780fe9add345052aef9ccb5d51f4";
    hash = "sha256-QH4w++kekejvvgTye6djs0jYzcNsxfrE3XCBed+Oizo=";
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
