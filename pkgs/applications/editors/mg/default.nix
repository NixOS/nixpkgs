{ fetchurl, stdenv, ncurses }:
stdenv.mkDerivation rec {
  name = "mg-20110905";

  src = fetchurl {
    url = http://homepage.boetes.org/software/mg/mg-20110905.tar.gz;
    sha256 = "0ac2c7wy5kkcflm7cmiqm5xhb5c4yfw3i33iln8civ1yd9z7vlqw";
  };

  dontAddPrefix = true;

  patches = [ ./configure.patch ];
  patchFlags = "-p0";

  installPhase = ''
    mkdir -p $out/bin
    cp mg $out/bin
    mkdir -p $out/share/man/man1
    cp mg.1 $out/share/man/man1
  '';

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://homepage.boetes.org/software/mg/;
    description = "mg is Micro GNU/emacs, this is a portable version of the mg maintained by the OpenBSD team";
    license = "public domain";
    platforms = stdenv.lib.platforms.all;
  };
}
