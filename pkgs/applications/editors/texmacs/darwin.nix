{ stdenv, callPackage, fetchurl,
  guile_1_8, qt4, zlib, freetype, CoreFoundation, Cocoa, gettext, libiconv, ghostscript,
  tex ? null,
  aspell ? null,
  netpbm ? null,
  imagemagick ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false }:
let
  version = "1.99.4";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
stdenv.mkDerivation {
  pname = "TeXmacs";
  inherit version;

  src= fetchurl {
    url = "http://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    sha256 = "1z8sj0xd1ncbl7ipzfsib6lmc7ahgvmiw61ln5zxm2l88jf7qc1a";
  };

  patches = [ ./darwin.patch ];

  buildInputs = [ guile_1_8.dev qt4 freetype CoreFoundation Cocoa gettext libiconv ghostscript ];

  GUILE_CPPFLAGS="-D_THREAD_SAFE -I${guile_1_8.dev}/include -I${guile_1_8.dev}/include/guile ";

  NIX_LDFLAGS="${zlib}/lib/libz.dylib";

  buildPhase = ''
    substituteInPlace Makefile \
      --replace 'find -d $(MACOS_PACKAGE_TEXMACS)' 'find $(MACOS_PACKAGE_TEXMACS) -depth' \
      --replace '$(MACOS_PACKAGE_SRC)/bundle-libs.sh' 'true'
    make MACOS_BUNDLE
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -R ../distr/TeXmacs-${version}.app $out/Applications
  '';

  inherit (common) postPatch;

  postInstall = "wrapProgram $out/Applications/TeXmacs-${version}/Contents/MacOS/TeXmacs --suffix PATH : " +
    "${ghostscript}/bin:" +
    (if aspell == null then "" else "${aspell}/bin:") +
    (if tex == null then "" else "${tex}/bin:") +
    (if netpbm == null then "" else "${stdenv.lib.getBin netpbm}/bin:") +
    (if imagemagick == null then "" else "${imagemagick}/bin:");

  enableParallelBuilding = true;

  meta = common.meta // {
    platforms = stdenv.lib.platforms.darwin;
  };
}
