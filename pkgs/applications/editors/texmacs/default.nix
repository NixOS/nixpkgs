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
  version = "1.99.14";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "1zbl1ddhppgnn3j213jl1b9mn8zmwnknxiqswm25p4llj0mqcgna";
  };

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
