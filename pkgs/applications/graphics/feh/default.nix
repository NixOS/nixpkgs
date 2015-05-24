{ stdenv, makeWrapper, fetchurl, x11, imlib2, libjpeg, libpng
, libXinerama, curl, libexif }:

stdenv.mkDerivation rec {
  name = "feh-2.13";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "06fa9zh1zpi63l90kw3l9a0sfavf424j7ksi396ifg9669gx35gn";
  };

  buildInputs = [ makeWrapper x11 imlib2 libjpeg libpng libXinerama curl libexif ];

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
