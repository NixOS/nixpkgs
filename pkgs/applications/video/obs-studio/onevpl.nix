{ stdenv
, fetchFromGitHub
, wayland
, wayland-protocols
, xorg
, libva
, libdrm
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "onevpl";
  version = "v2023.3.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneVPL";
    rev = version;
    hash = "sha256-kFW5n3uGTS+7ATKAuVff5fK3LwEKdCQVgGElgypmrG4=";
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    wayland
    wayland-protocols
    xorg.libxcb
    xorg.libX11
    xorg.libpciaccess
    libva
    libdrm
  ];
  cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DENABLE_DRI3=ON"
      "-DENABLE_DRM=ON"
      "-DENABLE_VA=ON"
      "-DENABLE_WAYLAND=ON"
      "-DENABLE_X11=ON"
  ];
}
