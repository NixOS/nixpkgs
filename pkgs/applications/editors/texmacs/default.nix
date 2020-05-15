{ stdenv, callPackage,
  fetchurl, guile_1_8, qt4, xmodmap, which, makeWrapper, freetype,
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
  version = "1.99.11";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "12bp0f34izzqimz49lfpgf4lyz3h45s9xbmk8v6zsawdjki76alg";
  };

  cmakeFlags = [
    # Texmacs' cmake build as of writing defaults to Qt5,
    # but we haven't updated to that yet.
    "-DTEXMACS_GUI=Qt4"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    guile_1_8
    qt4
    makeWrapper
    ghostscriptX
    freetype
    libjpeg
    sqlite
    git
    python3
  ];
  NIX_LDFLAGS = "-lz";

  postInstall = "wrapProgram $out/bin/texmacs --suffix PATH : " +
        (if ghostscriptX == null then "" else "${ghostscriptX}/bin:") +
        (if aspell == null then "" else "${aspell}/bin:") +
        (if tex == null then "" else "${tex}/bin:") +
        (if git == null then "" else "${git}/bin:") +
        (if python3 == null then "" else "${python3}/bin:") +
        "${xmodmap}/bin:${which}/bin";

  inherit (common) postPatch;

  meta = common.meta // {
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
