{
  lib,
  fetchurl,
  perlPackages,
  pkg-config,
  SDL,
  SDL_mixer,
  SDL_Pango,
  glib,
  copyDesktopItems,
  makeDesktopItem,
  fetchpatch,
}:

perlPackages.buildPerlModule {
  pname = "frozen-bubble";
  version = "2.212";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KT/KTHAKORE/Games-FrozenBubble-2.212.tar.gz";
    hash = "sha256-ch4E/2nFIzBgZWv79AAqoa6t2WyVNR8MV7uFtto1owU=";
  };

  patches = [
    ./fix-compilation.patch
    (fetchpatch {
      # https://github.com/kthakore/frozen-bubble/pull/82
      url = "https://github.com/kthakore/frozen-bubble/commit/1aacc67254a0aafd856086cc306e9f7b389c6bf4.patch?full_index=1";
      hash = "sha256-RqJ+/UFv4esKWZBk0fttsEXhPMislEBTAl2oj4pLAZY=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
  ];

  buildInputs = [
    glib
    SDL
    SDL_mixer
    SDL_Pango
    perlPackages.SDL
    perlPackages.FileSlurp
  ];

  propagatedBuildInputs = with perlPackages; [
    AlienSDL
    CompressBzip2
    FileShareDir
    FileWhich
    IPCSystemSimple
    LocaleMaketextLexicon
  ];

  perlPreHook = "export LD=$CC";

  desktopItems = [
    (makeDesktopItem {
      name = "frozen-bubble";
      exec = "frozen-bubble";
      desktopName = "Frozen Bubble";
      genericName = "Frozen Bubble";
      comment = "Arcade/reflex colour matching game";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Puzzle with Bubbles";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ puckipedia ];
  };
}
