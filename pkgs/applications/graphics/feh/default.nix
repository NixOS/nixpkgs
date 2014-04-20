{ stdenv, makeWrapper, fetchurl, x11, imlib2, libjpeg, libpng, giblib
, libXinerama, curl }:

stdenv.mkDerivation rec {
  name = "feh-2.10";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "10ya8j0mxlni08qli3gdkyjhy54g4d2q2kc0hhragmzd9s42ly5w";
  };

  buildInputs = [makeWrapper x11 imlib2 giblib libjpeg libpng libXinerama curl ];

  preBuild = ''
    makeFlags="PREFIX=$out"
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg}/bin"
  '';

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
