{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libpng,
  libjpeg,
  libX11,
  glew,
  openal,
  cmake,
  pkg-config,
  libmad,
  libuuid,
  minizip,
}:

stdenv.mkDerivation rec {
  pname = "endless-sky";
  version = "0.10.14";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    tag = "v${version}";
    hash = "sha256-/jW9TXmK2xgHUQe6H+WSCHPQthxvoNepdkdnOD3sXXo=";
  };

  patches = [
    ./fixes.patch
  ];

  postPatch = ''
    # the trailing slash is important!!
    # endless sky naively joins the paths with string concatenation
    # so it's essential that there be a trailing slash on the resources path
    substituteInPlace source/Files.cpp \
      --replace-fail '%NIXPKGS_RESOURCES_PATH%' "$out/share/games/endless-sky/"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    libpng
    libjpeg
    libX11
    glew
    openal
    libmad
    libuuid
    minizip
  ];

  meta = with lib; {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    license = with licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = with maintainers; [
      _360ied
      lilacious
    ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
