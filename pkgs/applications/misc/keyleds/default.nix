{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, libuv
, libX11
, libXi
, libyaml
, luajit
, udev
}:

stdenv.mkDerivation rec {
  pname = "keyleds";
  version = "unstable-2021-04-08";

  src = fetchFromGitHub {
    owner = "keyleds";
    repo = pname;
    rev = "171361654a64b570d747c2d196acb2da4b8dc293";
    sha256 = "sha256-mojgHMT0gni0Po0hiZqQ8eMzqfwUipXue1uqpionihw=";
  };

  # This commit corresponds to the following open PR:
  # https://github.com/keyleds/keyleds/pull/74
  # According to the author of the PR, the maintainer of keyleds is unreachable.
  # This patch fixes the build process which is broken on the current master branch of keyleds.
  patches = [
    (fetchpatch {
      url = "https://github.com/keyleds/keyleds/commit/bffed5eb181127df915002b6ed830f85f15feafd.patch";
      sha256 = "sha256-i2N3D/K++34JVqJloNK2UcN473NarIjdjAz6PUhXcNY=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libuv
    libX11
    libXi
    libyaml
    luajit
    udev
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=MinSizeRel"
  ];

  meta = {
    homepage = "https://github.com/keyleds/keyleds";
    description = "Advanced RGB animation service for Logitech keyboards";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
