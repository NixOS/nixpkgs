{ stdenv, makeWrapper, fetchurl, xlibsWrapper, imlib2, libjpeg, libpng
, libXinerama, curl, libexif, perlPackages }:

stdenv.mkDerivation rec {
  name = "feh-2.16.1";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1cxnc8dxyl7s4qnkvdjaqx7gdvc6brxpq0qbg91mljg47fd2hmbf";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ xlibsWrapper imlib2 libjpeg libpng libXinerama curl libexif ]
    ++ stdenv.lib.optional doCheck [ perlPackages.TestCommand perlPackages.TestHarness ];

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
