{stdenv, fetchurl, gmp, mpfr, pari, ntl, gsl, blas,
readline, gettext, liblapackWithAtlas, bison, yacc, flex,
mpfi,  libpng, libao, gfortran, texlive, hevea, perl,
enableGui ? true, mesa ? null, xorg ? null, fltk ? null,
}:

assert enableGui -> mesa != null && xorg != null && fltk != null;

stdenv.mkDerivation rec {
  name = "giac-${version}";
  version = "1.4.9";

  src = fetchurl {
    url = "https://www-fourier.ujf-grenoble.fr/~parisse/giac/${name}.tar.bz2";
    sha256 = "1n7xxgpqrsq7cv5wgcmgag6jvxw5wijkf1yv1r5aizlf1rc7dhai";
  };


  patchPhase = ''
    for i in doc/*/Makefile* ; do
      substituteInPlace "$i" --replace "/bin/cp" "cp";
    done;
    '';

  nativeBuildInputs = [
    texlive.combined.scheme-small hevea
  ];

  buildInputs = [
    gmp mpfr pari ntl gsl mpfi liblapackWithAtlas bison yacc flex readline
    gettext blas libpng gfortran perl
  ] ++ stdenv.lib.optionals enableGui [
    mesa fltk xorg.libX11
  ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" "bindnow" "relro" ];

  configureFlags = [
      "--enable-gc" "--enable-png" "--enable-gsl" "--enable-lapack"
      "--enable-pari" "--enable-ntl" "--enable-gmpxx" # "--enable-cocoa"
      "--enable-ao" ] ++ stdenv.lib.optionals enableGui [
      "--enable-gui" "--with-x"
    ];

  postInstall = ''
    # example Makefiles contain the full path to some commands
    # notably texlive, and we don't want texlive to become a runtime
    # dependency
    for file in $(find $out -name Makefile) ; do
      sed -i "s@/nix/store/[^/]*/bin/@@" "$file" ;
    done;
  '';

  meta = with stdenv.lib; {
    description = "A free computer algebra system (CAS)";
    homepage = "https://www-fourier.ujf-grenoble.fr/~parisse/giac.html";
    license = licenses.gpl3Plus;
    ## xcas is buildable on darwin but there are specific instructions I could
    ## not test
    platforms = platforms.linux;
  };
}
