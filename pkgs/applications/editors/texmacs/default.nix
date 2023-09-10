{ lib, mkDerivation, callPackage, fetchurl,
  guile_1_8, qtbase, xmodmap, which, freetype,
  libjpeg,
  sqlite,
  tex ? null,
  aspell ? null,
  git ? null,
  python3 ? null,
  cmake,
  pkg-config,
  ghostscriptX ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false }:

let
  pname = "TeXmacs";
  version = "2.1";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "1gl6k1bwrk1y7hjyl4xvlqvmk5crl4jvsk8wrfp7ynbdin6n2i48";
  };

  nativeBuildInputs = [ cmake pkg-config ];
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
