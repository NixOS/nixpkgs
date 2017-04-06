{ fetchurl, stdenv, ncurses, pkgconfig, libbsd }:
stdenv.mkDerivation rec {
  name = "mg-${version}";
  version = "20161005";

  src = fetchurl {
    url = "http://homepage.boetes.org/software/mg/${name}.tar.gz";
    sha256 = "0qaydk2cy765n9clghmi5gdnpwn15y2v0fj6r0jcm0v7d89vbz5p";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";
  
  preConfigure = ''
    substituteInPlace GNUmakefile \
      --replace /usr/bin/pkg-config ${pkgconfig}/bin/pkg-config
      '';

  installPhase = ''
    mkdir -p $out/bin
    cp mg $out/bin
    mkdir -p $out/share/man/man1
    cp mg.1 $out/share/man/man1
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libbsd ];

  meta = with stdenv.lib; {
    homepage = http://homepage.boetes.org/software/mg/;
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
