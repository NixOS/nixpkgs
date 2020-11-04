{ lib, stdenv, fetchFromGitHub, fetchpatch, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg, djvulibre
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg, libwebp, fftw, libheif, libde265
, ApplicationServices
}:

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then "i686"
    else if stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin" then "x86-64"
    else if stdenv.hostPlatform.system == "armv7l-linux" then "armv7l"
    else if stdenv.hostPlatform.system == "aarch64-linux" then "aarch64"
    else if stdenv.hostPlatform.system == "powerpc64le-linux" then "ppc64le"
    else throw "ImageMagick is not supported on this platform.";

  cfg = {
    version = "6.9.11-29";
    sha256 = "0adjdpi91ya0g3v7y503n95833m25aibkim5swg5lnwjrba407hg";
    patches = [];
  }
    # Freeze version on mingw so we don't need to port the patch too often.
    # FIXME: This version has multiple security vulnerabilities
    // lib.optionalAttrs (stdenv.hostPlatform.isMinGW) {
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

stdenv.mkDerivation {
  pname = "imagemagick";
  inherit (cfg) version;

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick6";
    rev = cfg.version;
    inherit (cfg) sha256;
  };

  patches = cfg.patches;

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
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
    ++ lib.optionals (stdenv.hostPlatform.isMinGW)
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkgconfig libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      libpng libtiff libxml2 libheif libde265 djvulibre
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ openexr librsvg openjpeg ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 fftw ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ libX11 libXext libXt libwebp ]
    ;

  doCheck = false; # fails 6 out of 76 tests

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace "${pkgconfig}/bin/pkg-config -config" \
        ${pkgconfig}/bin/${pkgconfig.targetPrefix}pkg-config
      substituteInPlace "$file" --replace ${pkgconfig}/bin/pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '${pkgconfig}/bin/${pkgconfig.targetPrefix}pkg-config'"
    done
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.imagemagick.org/";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
  };
}
