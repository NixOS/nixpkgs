{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg, libwebp
}:

let
  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else if stdenv.system == "armv7l-linux" then "armv7l"
    else throw "ImageMagick is not supported on this platform.";

  cfg = {
    version = "6.9.3-9";
    sha256 = "0q19jgn1iv7zqrw8ibxp4z57iihrc9kyb09k2wnspcacs6vrvinf";
    patches = [];
  }
    # Freeze version on mingw so we don't need to port the patch too often.
    // lib.optionalAttrs (stdenv.cross.libc or null == "msvcrt") {
        version = "6.9.2-0";
        sha256 = "17ir8bw1j7g7srqmsz3rx780sgnc21zfn0kwyj78iazrywldx8h7";
        patches = [(fetchpatch {
          name = "mingw-build.patch";
          url = "https://raw.githubusercontent.com/Alexpux/MINGW-packages/"
            + "01ca03b2a4ef/mingw-w64-imagemagick/002-build-fixes.patch";
          sha256 = "1pypszlcx2sf7wfi4p37w1y58ck2r8cd5b2wrrwr9rh87p7fy1c0";
        })];
      };
in

stdenv.mkDerivation rec {
  name = "imagemagick-${version}";
  inherit (cfg) version;

  src = fetchurl {
    urls = [
      "mirror://imagemagick/releases/ImageMagick-${version}.tar.xz"
      # the original source above removes tarballs quickly
      "http://distfiles.macports.org/ImageMagick/ImageMagick-${version}.tar.xz"
    ];
    inherit (cfg) sha256;
  };

  patches = [ ./imagetragick.patch ] ++ cfg.patches;

  outputs = [ "dev" "out" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ [ "--with-gcc-arch=${arch}" ]
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optionals (ghostscript != null)
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ]
    ++ lib.optionals (stdenv.cross.libc or null == "msvcrt")
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkgconfig libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      libpng libtiff libxml2
    ]
    ++ lib.optionals (stdenv.cross.libc or null != "msvcrt")
      [ openexr librsvg openjpeg ]
    ;

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 ]
    ++ lib.optionals (stdenv.cross.libc or null != "msvcrt")
      [ libX11 libXext libXt libwebp ]
    ;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '${pkgconfig}/bin/pkg-config'"
    done
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ the-kenny wkennington ];
  };
}
