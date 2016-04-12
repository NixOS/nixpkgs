{ stdenv, makeWrapper, fetchurl, xlibsWrapper, imlib2, libjpeg, libpng
, libXinerama, curl, libexif }:

stdenv.mkDerivation rec {
  name = "feh-2.15";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0fdbpfzbx3hgzi6jcmz1zv5lrxvgasc54bvqdzg8hhh4ql5s5fj2";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ xlibsWrapper imlib2 libjpeg libpng libXinerama curl libexif ];

  preBuild = ''
    makeFlags="PREFIX=$out exif=1"
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg}/bin" \
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
