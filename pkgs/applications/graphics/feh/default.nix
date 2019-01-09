{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "feh-${version}";
  version = "3.1.1";

  src = fetchurl {
    url = "https://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1sy8z6rv5sy1bhk3846hgfdy96wdi874yr2fnxfprks46qp29l31";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=$(out)" "exif=1"
  ] ++ optional stdenv.isDarwin "verscmp=0";

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

  checkInputs = [ perlPackages.perl perlPackages.TestCommand ];
  preCheck = ''
    export PERL5LIB="${perlPackages.TestCommand}/${perlPackages.perl.libPrefix}"
  '';

  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    license = licenses.mit;
    maintainers = [ maintainers.viric maintainers.willibutz ];
    platforms = platforms.unix;
  };
}
