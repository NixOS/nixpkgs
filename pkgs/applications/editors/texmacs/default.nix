{ lib, mkDerivation, callPackage, fetchurl, fetchpatch,
  guile_1_8, qtbase, xmodmap, which, freetype,
  libjpeg,
  sqlite,
  tex ? null,
  aspell ? null,
  git ? null,
  python3 ? null,
  cmake,
  pkgconfig,
  ghostscriptX ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false }:

let
  pname = "TeXmacs";
  version = "1.99.13";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "Aq0cS47QqmFQHelxRjANeJlgXCXagnYRykpAq7wHqbQ=";
  };

  patches = [
    # Minor patch for Qt 5.15 support, should be included in next release.
    (fetchpatch {
      url = "https://github.com/texmacs/texmacs/commit/3cf56af92326b74538f5e943928199ba6e963d0b.patch";
      sha256 = "+OBQmnKgvQZZkLx6ea773Dwq0o7L92Sex/kcVUhmg6Q=";
    })
    # Fix returned version, lets hope they remember to bump the version next release.
    (fetchpatch {
      url = "https://github.com/texmacs/texmacs/commit/da5b67005d2fc31bb32ea1ead882c26af12d8cbb.patch";
      sha256 = "czMgdraQErrdvN83jY76P673L52BpQkDwntmKvF0Ykg=";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    guile_1_8
    qtbase
    ghostscriptX
    freetype
    libjpeg
    sqlite
    git
    python3
  ];
  NIX_LDFLAGS = "-lz";

  qtWrapperArgs = [
    "--suffix" "PATH" ":" (lib.makeBinPath [
      xmodmap
      which
      ghostscriptX
      aspell
      tex
      git
      python3
    ])
  ];

  postFixup = ''
    wrapQtApp $out/bin/texmacs
  '';

  inherit (common) postPatch;

  meta = common.meta // {
    maintainers = [ lib.maintainers.roconnor ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
