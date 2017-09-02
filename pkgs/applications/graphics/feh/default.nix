{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "feh-${version}";
  version = "2.19.3";

  src = fetchurl {
    url = "http://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1l3yvv0l0ggwlfyhk84p2g9mrqvzqrg1fgalf88kzppvb9jppjay";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ]
    ++ optionals doCheck [ perlPackages.TestCommand perlPackages.TestHarness ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  preBuild = ''
    makeFlags="PREFIX=$out exif=1"
  '';

  postBuild = ''
    pushd man
    make
    popd
  '';

  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg.bin}/bin" \
                               --add-flags '--theme=feh'
    install -D -m 644 man/*.1 $out/share/man/man1
  '';

  checkPhase = ''
    PERL5LIB="${perlPackages.TestCommand}/lib/perl5/site_perl" make test
  '';

  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = https://derf.homelinux.org/projects/feh/;
    license = licenses.mit;
    maintainers = [ maintainers.viric maintainers.willibutz ];
    platforms = platforms.unix;
  };
}
