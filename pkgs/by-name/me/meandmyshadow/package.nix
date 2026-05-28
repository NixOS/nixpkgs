{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  freetype,
  curl,
  libarchive,
  lua5_3,
  libx11,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meandmyshadow";
  version = "0.5a-unstable-2024-12-12";

  src = fetchFromGitHub {
    owner = "acmepjz";
    repo = "meandmyshadow";
    rev = "28392b7a770c12e3ac1dd6cdfc85b0a66b6a300b";
    hash = "sha256-YIszFi1I66h4Db1GYOqApYOYzt88V6q68NOCNP8NzVo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    freetype
    curl
    libarchive
    lua5_3
    libx11
  ];

  #Fix the upstream code with modern standards
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMake_Minimum_Required (VERSION 3.1)" \
                    "CMake_Minimum_Required (VERSION 3.10)"

    substituteInPlace src/EasterEggScreen.cpp \
      --replace-fail 'char date[8];' 'char date[32];'

    substituteInPlace src/MusicManager.h \
      --replace-fail 'typedef struct _Mix_Music Mix_Music;' \
                    'typedef struct Mix_Music Mix_Music;'
  '';
  #Fix image icon location warning
  postInstall = ''
    install -Dm644 \
      $out/share/icons/hicolor/16x16/apps/meandmyshadow.png \
      $out/share/meandmyshadow/icons/16x16/meandmyshadow.png
  '';

  #Force the renderer under X11
  postFixup = ''
    wrapProgram $out/bin/meandmyshadow \
      --set SDL_VIDEODRIVER x11
  '';

  meta = {
    description = "Puzzle platform game where you cooperate with your shadow to reach exit";
    homepage = "https://github.com/acmepjz/meandmyshadow";
    mainProgram = "meandmyshadow";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
