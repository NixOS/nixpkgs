{ lib, stdenv, fetchgit, cmake, pkgconfig
, wlc, dbus_libs, wayland, libxkbcommon, pixman, libinput, udev, zlib, libpng
, libdrm, libX11
}:

stdenv.mkDerivation rec {
  name = "orbment-${version}";
  version = "git-2016-08-13";

  src = fetchgit {
    url = "https://github.com/Cloudef/orbment";
    rev = "01dcfff9719e20261a6d8c761c0cc2f8fa0d0de5";
    sha256 = "04mv9nh847vijr01zrs47fzmnwfhdx09vi3ddv843mx10yx7lqdb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    wlc dbus_libs wayland libxkbcommon pixman libinput udev zlib libpng libX11
    libdrm
  ];

  meta = {
    description = "Modular Wayland compositor";
    homepage    = src.url;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
