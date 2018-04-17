{ stdenv, callPackage,
  fetchurl, guile_1_8, qt4, zlib, xmodmap, which, makeWrapper, freetype,
  tex ? null,
  aspell ? null,
  ghostscriptX ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false }:

let
  pname = "TeXmacs";
  version = "1.99.2";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "0l48g9746igiaxw657shm8g3xxk565vzsviajlrxqyljbh6py0fs";
  };

  buildInputs = [ guile_1_8 qt4 makeWrapper ghostscriptX freetype ];

  postInstall = "wrapProgram $out/bin/texmacs --suffix PATH : " +
        (if ghostscriptX == null then "" else "${ghostscriptX}/bin:") +
        (if aspell == null then "" else "${aspell}/bin:") +
        (if tex == null then "" else "${tex}/bin:") +
        "${xmodmap}/bin:${which}/bin";

  inherit (common) postPatch;

  postFixup = ''
    bin="$out/libexec/TeXmacs/bin/texmacs.bin"
    rpath=$(patchelf --print-rpath "$bin")
    patchelf --set-rpath "$rpath:${zlib.out}/lib" "$bin"
  '';

  meta = common.meta // {
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
