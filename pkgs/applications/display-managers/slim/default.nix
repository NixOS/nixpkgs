{stdenv, fetchurl, x11, libjpeg, libpng, libXmu, freetype, pam}:

stdenv.mkDerivation rec {
  name = "slim-1.3.1";

  src = fetchurl {
    url = "http://download.berlios.de/slim/${name}.tar.gz";
    sha256 = "0xqgzvg6h1bd29140mcgg9r16vcmskz7zmym7i7jlz7x9c1a9mxc";
  };

  patches = [
    # Allow the paths of the configuration file and theme directory to
    # be set at runtime.
    ./runtime-paths.patch

    # Fix a bug in slim's PAM support: the "resp" argument to the
    # conversation function is a pointer to a pointer to an array of
    # pam_response structures, not a pointer to an array of pointers to
    # pam_response structures.  Of course C can't tell the difference...
    ./pam.patch

    # Don't set PAM_RHOST to "localhost", it confuses ConsoleKit
    # (which assumes that a non-empty string means a remote session).
    ./pam2.patch
    
    ./slim-1.3.1-gcc4.4.patch
  ];

  buildInputs = [x11 libjpeg libpng libXmu freetype pam];

  NIX_CFLAGS_COMPILE = "-I${freetype}/include/freetype2";

  preBuild = ''
    substituteInPlace Makefile --replace /usr /no-such-path
    makeFlagsArray=(CC=gcc CXX=g++ PREFIX=$out MANDIR=$out/share/man CFGDIR=$out/etc USE_PAM=1)
  '';

  meta = {
    homepage = http://slim.berlios.de;
  };
}
