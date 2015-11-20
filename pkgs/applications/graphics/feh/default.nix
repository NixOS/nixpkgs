{ stdenv, makeWrapper, fetchurl, xlibsWrapper, imlib2, libjpeg, libpng
, libXinerama, curl, libexif }:

stdenv.mkDerivation rec {
  name = "feh-2.14";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0j5wxpqccnd0hl74z2vwv25n7qnik1n2mcm2jn0c0z7cjn4wsa9q";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ xlibsWrapper imlib2 libjpeg libpng libXinerama curl libexif ];

  preBuild = ''
    makeFlags="PREFIX=$out exif=1"
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg.bin}/bin" \
                               --add-flags '--theme=feh'
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; unix;
  };
}
