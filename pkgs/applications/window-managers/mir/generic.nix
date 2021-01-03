{ stdenv, fetchFromGitHub
, cmake, pkg-config
, wayland, boost, egl-wayland, wlcs, libglvnd, glm, protobuf, capnproto, glog, lttng-ust, udev, glib, libxcb, libX11, libXau, libXcursor, libXdmcp, libXrender, libdrm, mesa, epoxy, nettle, libxkbcommon, libinput, libxmlxx, libuuid, freetype, libyamlcpp, python3, libevdev, umockdev, gtest, libsystemtap

, version
, sha256
}:

let
  # TODO tested at build time, figure out what for?
  # share has unwrapped python scripts for Mir debugging
  py = python3.withPackages (ps: with ps; [ pillow ]);
in
stdenv.mkDerivation rec {
  pname = "mir";
  inherit version;

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "mir";
    rev = "v${version}";
    inherit sha256;
  };

  postPatch = ''
    for cmakeFile in src{,/platforms}/CMakeLists.txt; do
      substituteInPlace $cmakeFile \
        --replace '$''\{CMAKE_INSTALL_PREFIX}/$''\{CMAKE_INSTALL_LIBDIR}' '$''\{CMAKE_INSTALL_FULL_LIBDIR}'
    done
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ wayland boost egl-wayland wlcs libglvnd glm protobuf capnproto glog lttng-ust udev glib libxcb libX11 libXau libXcursor libXdmcp libXrender libdrm mesa epoxy nettle libxkbcommon libinput libxmlxx libuuid freetype libyamlcpp py libevdev umockdev gtest libsystemtap ];

  propagatedBuildInputs = [ libxkbcommon ];

  meta = with stdenv.lib; {
    description = "The Mir compositor";
    longDescription = ''
      Mir is set of libraries for building Wayland based shells. Mir simplifies the
      complexity that shell authors need to deal with: it provides a stable, well
      tested and performant platform with touch, mouse and tablet input, multi-display
      capability and secure client-server communications.
    '';
    homepage = "https://mir-server.io/";
    license = with licenses; [ gpl2Only gpl3Only lgpl2Only lgpl3Only ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
