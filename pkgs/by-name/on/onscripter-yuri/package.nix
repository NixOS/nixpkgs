{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  lua,
  bzip2,
  libjpeg,
  libogg,
  libvorbis,
}:

stdenv.mkDerivation rec {
  pname = "onscripter-yuri";
  version = "0.7.6beta2";

  src = fetchFromGitHub {
    owner = "YuriSizuku";
    repo = "OnscripterYuri";
    rev = "v${version}";
    hash = "sha256-NKB11h/s9ZX9HvhPaCK2qZenB8df2sEprGKb1DGNvOg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
    lua
    bzip2
    libjpeg
    libogg
    libvorbis
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = with lib; {
    description = "An enhancement ONScripter project porting to many platforms, especially web";
    homepage = "https://github.com/YuriSizuku/OnscripterYuri";
    license = licenses.gpl2Only;
    maintainers = with lib.maintainers; [ itsmyowninvention ];
    platforms = platforms.linux;
  };
}
