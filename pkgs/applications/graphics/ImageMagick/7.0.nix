{ lib, stdenv, fetchFromGitHub, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg, libwebp, libheif
, ApplicationServices
, hostPlatform
}:

let
  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else if stdenv.system == "armv7l-linux" then "armv7l"
    else if stdenv.system == "aarch64-linux" then "aarch64"
    else throw "ImageMagick is not supported on this platform.";

  cfg = {
    version = "7.0.8-6";
    sha256 = "1v7m1g9a7fqc8nravvv3dy54nzd3ip75hcnkdrpb5wbiz9pqgzi3";
    patches = [];
  };
in

stdenv.mkDerivation rec {
  name = "imagemagick-${version}";
  inherit (cfg) version;

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick";
    rev = cfg.version;
    inherit (cfg) sha256;
  };

  patches = [ ./imagetragick.patch ] ++ cfg.patches;

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
    ++ lib.optionals hostPlatform.isMinGW
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkgconfig libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      libpng libtiff libxml2 libheif
    ]
    ++ lib.optionals (!hostPlatform.isMinGW)
      [ openexr librsvg openjpeg ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 ]
    ++ lib.optionals (!hostPlatform.isMinGW)
      [ libX11 libXext libXt libwebp ]
    ;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16HDRI" "$dev" # includes configure params
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
    license = licenses.asl20;
    maintainers = with maintainers; [ the-kenny wkennington ];
  };
}
