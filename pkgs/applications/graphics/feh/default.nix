{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, perlPackages }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "feh-${version}";
  version = "3.1.3";

  src = fetchurl {
    url = "https://feh.finalrewind.org/${name}.tar.bz2";
    sha256 = "1vsnxf4as3vyzjfhd8frzb1a8i7wnq7ck5ljx7qxqrnfqvxl1s4z";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=${placeholder "out"}" "exif=1"
  ] ++ optional stdenv.isDarwin "verscmp=0";

  installTargets = [ "install" ];
  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${libjpeg.bin}/bin" \
                               --add-flags '--theme=feh'
  '';

  checkInputs = [ perlPackages.perl perlPackages.TestCommand ];
  preCheck = ''
    export PERL5LIB="${perlPackages.TestCommand}/${perlPackages.perl.libPrefix}"
  '';
  postCheck = ''
    unset PERL5LIB
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
