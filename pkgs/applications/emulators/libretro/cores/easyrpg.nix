{
  lib,
  fetchFromGitHub,
  cmake,
  fetchpatch,
  fmt,
  freetype,
  harfbuzz,
  liblcf,
  libpng,
  libsndfile,
  libvorbis,
  libxmp,
  mkLibretroCore,
  mpg123,
  opusfile,
  pcre,
  pixman,
  pkg-config,
  speexdsp,
}:
mkLibretroCore {
  core = "easyrpg";
  version = "0.8-unstable-2023-04-29";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = "f8e41f43b619413f95847536412b56f85307d378";
    hash = "sha256-nvWM4czTv/GxY9raomBEn7dmKBeLtSA9nvjMJxc3Q8s=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [
    cmake
    pkg-config
  ];
  extraBuildInputs = [
    fmt
    freetype
    harfbuzz
    liblcf
    libpng
    libsndfile
    libvorbis
    libxmp
    mpg123
    opusfile
    pcre
    pixman
    speexdsp
  ];
  patches = [
    # The following patch is shared with easyrpg-player.
    # Update when new versions of liblcf and easyrpg-player are released.
    # See easyrpg-player expression for details.
    (fetchpatch {
      name = "0001-Fix-building-with-fmtlib-10.patch";
      url = "https://github.com/EasyRPG/Player/commit/ab6286f6d01bada649ea52d1f0881dde7db7e0cf.patch";
      hash = "sha256-GdSdVFEG1OJCdf2ZIzTP+hSrz+ddhTMBvOPjvYQHy54=";
    })
  ];
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DPLAYER_TARGET_PLATFORM=libretro"
    "-DCMAKE_INSTALL_DATADIR=${placeholder "out"}/share"
  ];
  makefile = "Makefile";

  meta = {
    description = "EasyRPG Player libretro port";
    homepage = "https://github.com/EasyRPG/Player";
    license = lib.licenses.gpl3Only;
  };
}
