{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  libX11,
  libXpm,
  libpng,
  makeDesktopItem,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ace-of-penguins";
  version = "1.4";

  src = fetchurl {
    url = "http://www.delorie.com/store/ace/ace-${finalAttrs.version}.tar.gz";
    hash = "sha256-H+47BTOSGkKHPAYj8z2HOgZ7HuxY8scMAUSRRueaTM4=";
  };

  patches = [
    # Fixes a bunch of miscompilations in modern environments
    ./fixup-miscompilations.patch
    # make-imglib.c:205:5: error: 'return' with no value, in function returning non-void [-Wreturn-mismatch]
    # imagelib.c:109:17: error: implicit declaration of function 'malloc' [-Wimplicit-function-declaration]
    ./fix-gcc-14.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    libX11
    libXpm
    libpng
    zlib
  ];

  desktopItems =
    let
      generateItem = gameName: {
        name = "ace-of-penguins-${gameName}";
        exec = "${placeholder "out"}/bin/${gameName}";
        comment = "Ace of Penguins ${gameName} Card Game";
        desktopName = gameName;
        genericName = gameName;
      };
    in
    map (x: makeDesktopItem (generateItem x)) [
      "canfield"
      "freecell"
      "golf"
      "mastermind"
      "merlin"
      "minesweeper"
      "pegged"
      "penguins"
      "solitaire"
      "spider"
      "taipedit"
      "taipei"
      "thornq"
    ];

  meta = {
    homepage = "http://www.delorie.com/store/ace/";
    description = "Solitaire games in X11";
    longDescription = ''
      The Ace of Penguins is a set of Unix/X solitaire games based on the ones
      available for Windows(tm) but with a number of enhancements that my wife
      says make my versions better :-)

      The latest version includes clones of freecell, golf, mastermind, merlin,
      minesweeper, pegged, solitaire, taipei (with editor!), and thornq (by
      Martin Thornquist).
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
