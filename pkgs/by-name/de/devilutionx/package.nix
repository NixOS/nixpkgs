{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  bzip2,
  cmake,
  pkg-config,
  gettext,
  libsodium,
  SDL2,
  SDL2_image,
  SDL_audiolib,
  simpleini,
  fmt,
  libpng,
  libtiff,
  libwebp,
  smpq,
}:

let
  # TODO: submit a PR upstream to allow system copies of these libraries where possible

  # fork with patches, far behind upstream
  asio = fetchurl {
    url = "https://github.com/diasurgical/asio/archive/4bcf552fcea3e1ae555dde2ab33bc9fa6770da4d.tar.gz";
    sha256 = "sha256-AFBy5OFsAzxZsiI4DirIHh+VjFkdalEhN9OGqhC0Cvc=";
  };

  # fork with patches, upstream seems to be dead
  libmpq = fetchurl {
    url = "https://github.com/diasurgical/libmpq/archive/b78d66c6fee6a501cc9b95d8556a129c68841b05.tar.gz";
    sha256 = "sha256-NIzZwr6cBn38uKLWzW+Uet5QiOFUPB5dsf3FsS22ruo=";
  };

  # not "real" package with pkg-config or cmake file, just collection of source files
  libsmackerdec = fetchurl {
    url = "https://github.com/diasurgical/libsmackerdec/archive/91e732bb6953489077430572f43fc802bf2c75b2.tar.gz";
    sha256 = "sha256-5WXjfvGuT4hG2cnCS4YbxW/c4tek7OR95EjgCqkEi4c=";
  };

  # fork with patches, far behind upstream
  libzt = fetchFromGitHub {
    owner = "diasurgical";
    repo = "libzt";
    fetchSubmodules = true;
    rev = "d6c6a069a5041a3e89594c447ced3f15d77618b8";
    sha256 = "sha256-ttRJLfaGHzhS4jd8db7BNPWROCti3ZxuRouqsL/M5ew=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "devilutionx";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "diasurgical";
    repo = "devilutionX";
    tag = finalAttrs.version;
    hash = "sha256-F23MTe7vMOgIBH6qm7X1+8gIMmN9E+d/GZnFsQZt2cM=";
  };

  patches = [ ./add-nix-share-path-to-mpq-search.patch ];

  postPatch = ''
    substituteInPlace 3rdParty/asio/CMakeLists.txt --replace-fail "${asio.url}" "${asio}"
    substituteInPlace 3rdParty/libmpq/CMakeLists.txt --replace-fail "${libmpq.url}" "${libmpq}"
    substituteInPlace 3rdParty/libsmackerdec/CMakeLists.txt --replace-fail "${libsmackerdec.url}" "${libsmackerdec}"
    substituteInPlace 3rdParty/libzt/CMakeLists.txt \
      --replace-fail "GIT_REPOSITORY https://github.com/diasurgical/libzt.git" "" \
      --replace-fail "GIT_TAG ${libzt.rev}" "SOURCE_DIR ${libzt}"
    substituteInPlace Source/init.cpp \
      --replace-fail "@assets@" "$out/share/diasurgical/devilutionx/"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    smpq # used to build devilutionx.mpq
  ];

  buildInputs = [
    bzip2
    fmt
    libpng
    libtiff
    libwebp
    libsodium
    SDL2
    SDL2_image
    SDL_audiolib
    simpleini
  ];

  meta = {
    homepage = "https://github.com/diasurgical/devilutionX";
    description = "Diablo build for modern operating systems";
    mainProgram = "devilutionx";
    longDescription = "In order to play this game a copy of diabdat.mpq is required. Place a copy of diabdat.mpq in ~/.local/share/diasurgical/devilution before executing the game.";
    license = lib.licenses.sustainableUse;
    maintainers = with lib.maintainers; [
      aanderse
    ];
    platforms = with lib.platforms; linux ++ windows;
  };
})
