{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  fetchItchIo,
  cmake,
  pkg-config,
  SDL2,
  SDL2_image,
  audiality2,
  useProprietaryAssets ? true,
}:

let
  inherit (lib)
    licenses
    maintainers
    optional
    optionalString
    platforms
    ;

  pname = "koboredux";
  version = "0.7.5.1";

  main_src = fetchFromGitHub {
    owner = "olofson";
    repo = "koboredux";
    tag = "v${version}";
    sha256 = "09h9r65z8bar2z89s09j6px0gdq355kjf38rmd85xb2aqwnm6xig";
  };

  assets_src = fetchItchIo {
    name = "koboredux-${version}-Linux.tar.bz2";
    gameUrl = "https://olofson.itch.io/kobo-redux";
    sha256 = "11bmicx9i11m4c3dp19jsql0zy4rjf5a28x4hd2wl8h3bf8cdgav";
    upload = "709961";
    extraMessage = ''
      Alternatively, install the "koboredux-free" package, which replaces the
      proprietary assets with a placeholder theme.
    '';
  };

in

stdenv.mkDerivation rec {
  inherit pname version;

  src = [ main_src ] ++ optional useProprietaryAssets assets_src;

  sourceRoot = main_src.name;

  # Fix clang build
  patches = [
    (fetchpatch {
      url = "https://github.com/olofson/koboredux/commit/cf92b8a61d002ccaa9fbcda7a96dab08a681dee4.patch";
      sha256 = "0dwhvis7ghf3mgzjd2rwn8hk3ndlgfwwcqaq581yc5rwd73v6vw4";
    })
  ];

  postPatch = ''
    # CMake 4 support
    # https://github.com/olofson/koboredux/pull/562
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8)' \
      'cmake_minimum_required(VERSION 2.8...4.1)'
  ''
  + optionalString useProprietaryAssets ''
    cp -r ../koboredux-${version}-Linux/sfx/redux data/sfx/
    cp -r ../koboredux-${version}-Linux/gfx/redux data/gfx/
    cp -r ../koboredux-${version}-Linux/gfx/redux_fullscreen data/gfx/
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    audiality2
  ];

  meta = {
    description =
      "Frantic 80's style 2D shooter, similar to XKobo and Kobo Deluxe"
      + optionalString (!useProprietaryAssets) " (built without proprietary assets)";
    mainProgram = "kobord";
    longDescription = ''
      Kobo Redux is a frantic 80's style 2D shooter, inspired by the look and
      feel of 90's arcade cabinets. The gameplay is fast and unforgiving,
      although with less of the frustrating quirkiness of the actual games
      of the 80's. A true challenge in the spirit of the arcade era!
    ''
    + optionalString (!useProprietaryAssets) ''

      This version replaces the official proprietary assets with placeholders.
      For the full experience, consider installing "koboredux" instead.
    '';
    homepage = "https://olofson.itch.io/kobo-redux";
    license = with licenses; if useProprietaryAssets then unfree else gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ fgaz ];
  };
}
