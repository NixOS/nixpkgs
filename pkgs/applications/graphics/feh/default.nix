{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "feh-${version}";
  version = "3.0";

  src = fetchurl {
    url = "https://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "00fwf8yz7k8vzd30ly5ndlj6ax9w85dkjzjnlk95vd0zdrf4wyxn";
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

  checkInputs = [ perlPackages.TestCommand perlPackages.TestHarness ];
  preCheck = ''
    export PERL5LIB="${perlPackages.TestCommand}/lib/perl5/site_perl"
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
