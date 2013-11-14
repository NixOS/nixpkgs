{ stdenv
, fetchurl
, pkgconfig
, bzip2
, fontconfig
, freetype
, ghostscript ? null
, libjpeg
, libpng
, libtiff
, libxml2
, zlib
, libtool
, jasper
, libX11
, tetex ? null
, librsvg ? null
}:

let
  version = "6.8.7-5";
in
stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.xz";
    sha256 = "1cn1kg7scs6r7r00qlqirhnmqjnmyczbidab3vgqarw9qszh2ri6";
  };

  enableParallelBuilding = true;

  preConfigure = if tetex != null then
    ''
      export DVIDecodeDelegate=${tetex}/bin/dvips
    '' else "";

  configureFlags = "" + stdenv.lib.optionalString (ghostscript != null && stdenv.system != "x86_64-darwin") ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
  '' + ''
    --with-frozenpaths
    ${if librsvg != null then "--with-rsvg" else ""}
  '';

  propagatedBuildInputs =
    [ bzip2 fontconfig freetype libjpeg libpng libtiff libxml2 zlib librsvg
      libtool jasper libX11
    ] ++ stdenv.lib.optional (ghostscript != null && stdenv.system != "x86_64-darwin") ghostscript;

  buildInputs = [ tetex pkgconfig ];

  postInstall = ''(cd "$out/include" && ln -s ImageMagick* ImageMagick)'';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ the-kenny ];
  };
}
