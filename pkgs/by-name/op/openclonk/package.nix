{
  lib,
  stdenv,

  # sources
  fetchurl,
  fetchFromGitHub,
  fetchDebianPatch,

  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,

  # buildInputs
  curl,
  freealut,
  freetype,
  glew,
  libb2,
  libepoxy,
  libjpeg,
  libogg,
  libpng,
  libvorbis,
  openal,
  readline,
  SDL2,
  tinyxml,

  # Enable the "Open Clonk Soundtrack - Explorers Journey" by David Oerther
  enableSoundtrack ? false,
}:

let
  soundtrack_src = fetchurl {
    url = "http://www.openclonk.org/download/Music.ocg";
    hash = "sha256-Mye6pl1eSgEQ/vOLfDsdHDjp2ljb3euGKBr7s36+2W4=";
  };
in
stdenv.mkDerivation {
  version = "9.0-unstable-2025-01-11";
  pname = "openclonk";

  src = fetchFromGitHub {
    owner = "openclonk";
    repo = "openclonk";
    rev = "db975b4a887883f4413d1ce3181f303d83ee0ab5";
    hash = "sha256-Vt7umsfe2TVZAeKJOXCi2ZCbSv6wAotuMflS7ii7Y/E=";
  };

  patches = [
    (fetchDebianPatch {
      pname = "openclonk";
      version = "8.1";
      debianRevision = "3";
      patch = "system-libb2.patch";
      hash = "sha256-zuH6zxSQXRhnt75092Xwb6XYv8UG391E5Arbnr7ApiI=";
    })
  ];

  postInstall = ''
    mv $out/games/openclonk $out/bin
    rm -r $out/games
  ''
  + lib.optionalString enableSoundtrack ''
    ln -sv ${soundtrack_src} $out/share/games/openclonk/Music.ocg
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    freealut
    freetype
    glew
    libb2
    libepoxy
    libjpeg
    libogg
    libpng
    libvorbis
    openal
    readline
    SDL2
    tinyxml
  ];

  cmakeBuildType = "RelWithDebInfo";

  meta = {
    description = "Free multiplayer action game in which you control clonks, small but witty and nimble humanoid beings";
    homepage = "https://www.openclonk.org";
    license = with lib.licenses; [ isc ] ++ lib.optional enableSoundtrack unfreeRedistributable;
    mainProgram = "openclonk";
    maintainers = with lib.maintainers; [ wolfgangwalther ];
    platforms = lib.platforms.linux;
  };
}
