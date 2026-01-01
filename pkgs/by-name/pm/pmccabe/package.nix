{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "pmccabe";
  version = "2.6";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/p/pmccabe/pmccabe_${version}.tar.gz";
    sha256 = "0a3h1b9fb87c82d5fbql5lc4gp338pa5s9i66dhw7zk8jdygx474";
  };

  patches = [ ./getopt_on_darwin.patch ];

  # GCC 14 made implicit function declarations an error. With this switch we turn them
  # back into a warning.
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  configurePhase = ''
    runHook preConfigure

    sed -i -r Makefile \
      -e 's,/usr/,/,g' \
      -e "s,^DESTDIR =.*$,DESTDIR = $out," \
      -e "s,^INSTALL = install.*$,INSTALL = install," \
      -e "s,^all:.*$,all: \$(PROGS),"

    runHook postConfigure
  '';

  checkPhase = "make test";

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "McCabe-style function complexity and line counting for C and C++";
    homepage = "https://people.debian.org/~bame/pmccabe/";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "McCabe-style function complexity and line counting for C and C++";
    homepage = "https://people.debian.org/~bame/pmccabe/";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    longDescription = ''
      pmccabe calculates McCabe-style cyclomatic complexity for C and
      C++ source code.  Per-function complexity may be used for
      spotting likely trouble spots and for estimating testing
      effort.

      pmccabe also includes a non-commented line counter, decomment which
      only removes comments from source code; codechanges, a program to
      calculate the amount of change which has occurred between two source
      trees or files; and vifn, to invoke vi given a function name rather
      than a file name.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
=======
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
