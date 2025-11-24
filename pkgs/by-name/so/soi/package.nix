{
  lib,
  stdenv,
  fetchurl,
  cmake,
  boost,
  eigen2,
  lua5_1,
  luabind,
  libGLU,
  libGL,
  SDL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soi";
  version = "0.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/soi/Spheres%20of%20Influence-${finalAttrs.version}-Source.tar.bz2";
    name = "soi-${finalAttrs.version}.tar.bz2";
    sha256 = "03c3wnvhd42qh8mi68lybf8nv6wzlm1nx16d6pdcn2jzgx1j2lzd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    lua5_1
    luabind
    libGLU
    libGL
    SDL
  ];

  cmakeFlags = [
    "-DEIGEN_INCLUDE_DIR=${eigen2}/include/eigen2"
    "-DLUABIND_LIBRARY=${luabind}/lib/libluabind09.a"
  ];

  # CMake 2.6 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  patches = [ ./cmake-4-build.patch ];

  meta = {
    description = "Physics-based puzzle game";
    mainProgram = "soi";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
    downloadPage = "https://sourceforge.net/projects/soi/files/";
  };
})
