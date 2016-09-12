{ stdenv, fetchurl, makeWrapper, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

stdenv.mkDerivation rec {
  name = "feh-2.17.1";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "0lyq17kkmjxj3vxpmri56linr1bnfmx5568pgrcjgd3amnj1is59";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ]
    ++ stdenv.lib.optional doCheck [ perlPackages.TestCommand perlPackages.TestHarness ];

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
