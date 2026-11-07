{
  stdenv,
  lib,
  fetchFromGitHub,
  argagg,
  cmake,
  gettext,
  pkg-config,
  ronn,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  sdl-kitchensink,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "planetblupi";
  version = "1.16.0-beta1";

  src = fetchFromGitHub {
    owner = "blupi-games";
    repo = "planetblupi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UyL/g36OF/iXOwoc4sAraZRhIPmz3xvmoM/WT/k8ZjU=";
  };

  postPatch =
    # CMake 3.2 minimum gets rejected by CMake 4.x
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'cmake_minimum_required (VERSION 3.2)' \
          'cmake_minimum_required (VERSION 3.5)'
    ''
    # Adjust license location. $out makes the text go off the screen.
    + ''
      substituteInPlace src/event.cxx resources/po/*.po \
        --replace-fail \
          ' share/doc' \
          ' $(which planetblupi)/../../share/doc'
    ''
    # Fullscreen behaves abit buggy, change default to windowed.
    + ''
      substituteInPlace resources/data/config.json \
        --replace-fail \
          '"fullscreen": true' \
          '"fullscreen": false'
    '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    ronn
  ];

  buildInputs = [
    argagg
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    sdl-kitchensink
  ];

  cmakeFlags = [
    (lib.strings.cmakeBool "PB_HTTP_VERSION_CHECK" false)
  ];

  meta = {
    description = "Real-time strategy game for ages 12 and up";
    longDescription = ''
      Planet Blupi (also known as Planet Eggbert) is a strategy and adventure game. It subtly blends action with
      thought-provoking challenges. Behind the quiet and gentle facade, you'll enjoy a fascinating diversion full of
      surprises. Planet Blupi is ideal for ages 12 to 99.

      This version contains over 30 missions and a built in editor, which enables you to construct your own missions.

      The game was freed (source code and all art files) and ported to all major platforms (Linux, macOS and Windows)
      for its 20th anniversary.

      This freed release has mostly the same look and functionalities that the original version of 1997, but with a
      portable code and some bugfixes.
    '';
    homepage = "https://www.blupi.org/planet/index.html";
    license = lib.licenses.gpl3Plus;
    mainProgram = "planetblupi";
    maintainers = [ lib.maintainers.OPNA2608 ];
    platforms = with lib.platforms; unix ++ windows;
    # https://github.com/blupi-games/planetblupi/issues/119
    badPlatforms = lib.platforms.bigEndian;
  };
})
