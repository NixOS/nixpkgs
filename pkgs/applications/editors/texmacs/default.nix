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
  version = "1.99.18";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "0il3fwgw20421aj90wg8kyhkwk6lbgb3bb2g5qamh5lk90yj725i";
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
