{ stdenv, makeWrapper, fetchurl, x11, imlib2, libjpeg, libpng
, libXinerama, curl }:

stdenv.mkDerivation rec {
  name = "feh-2.12";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0ckhidmsms2l5jycp0qf71jzmb3bpbhjq3bcgfpvfvszah7pmq30";
  };

  buildInputs = [makeWrapper x11 imlib2 libjpeg libpng libXinerama curl];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg}/bin" \
                               --add-flags '--theme=feh'
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
