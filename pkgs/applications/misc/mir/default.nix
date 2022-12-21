{ lib
, pkgs
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, boost
, egl-wayland
, libglvnd
, glm
, glog
, lttng-ust
, udev
, glib
, wayland
, libxcb
, xorg
, libdrm
, mesa
, libepoxy
, nettle
, libxkbcommon
, libinput
, libxmlxx
, libuuid
, pcre2
, freetype
, libyamlcpp
, python39Packages
, libevdev
}:

stdenv.mkDerivation rec {
  pname = "mir";
  version = "unstable-2022-12-16";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "mir";
    rev = "f9a5f64646170a2160fd1207bfac6701bee73347";
    sha256 = "sha256-eeDdctT4tOL3jQwFjSu6SfOLn5AtuJ6r6sDXlbVU8ko=";
  };

  postPatch = ''
    # Fix broken path found in pc file
    sed -i "s|/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_LIBDIR@|" src/core/mircore.pc.in
    sed -i "s|/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_INCLUDEDIR@|" src/core/mircore.pc.in
    sed -i "s|/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_INCLUDEDIR@|" src/renderers/gl/mir-renderer-gl-dev.pc.in
    sed -i "s|/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_LIBDIR@|" src/miral/miral.pc.in
    sed -i "s|/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_INCLUDEDIR@|" src/miral/miral.pc.in
    sed -i "s|/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_INCLUDEDIR@|" src/renderer/mirrenderer.pc.in
    sed -i "s|/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_LIBDIR@|" src/miroil/miroil.pc.in
    sed -i "s|/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_INCLUDEDIR@|" src/miroil/miroil.pc.in
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    boost
    egl-wayland
    libglvnd
    glm
    glog
    lttng-ust
    udev
    glib
    wayland
    libxcb
    xorg.libXcursor
    xorg.xorgproto
    xorg.libX11
    libdrm
    mesa
    libepoxy
    nettle
    libxkbcommon
    libinput
    libxmlxx
    libuuid
    pcre2
    freetype
    libyamlcpp
    python39Packages.pillow
    libevdev
  ];

  # Tests depend on further packages which are not yet packaged
  cmakeFlags = [ "-DMIR_ENABLE_TESTS=OFF" ];

  meta = with lib; {
    description = "Compositor and display server used by Canonical";
    homepage = "https://github.com/MirServer/mir";
    license = with licenses; [
      gpl2Only
      gpl3Only
      lgpl2Only
      lgpl3Only
    ];
    maintainers = with maintainers; [ onny ];
  };

}
