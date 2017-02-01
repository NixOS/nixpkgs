{ stdenv, fetchurl, makeWrapper, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

stdenv.mkDerivation rec {
  name = "feh-2.18.1";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1ck55rhh5ax1d9k9gy2crvyjwffh6028f4kxaisd8ymgbql40f2c";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ]
    ++ stdenv.lib.optionals doCheck [ perlPackages.TestCommand perlPackages.TestHarness ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  preBuild = ''
    makeFlags="PREFIX=$out exif=1"
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg.bin}/bin" \
                               --add-flags '--theme=feh'
  '';

  checkPhase = ''
    PERL5LIB="${perlPackages.TestCommand}/lib/perl5/site_perl" make test
  '';
  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; unix;
  };
}
