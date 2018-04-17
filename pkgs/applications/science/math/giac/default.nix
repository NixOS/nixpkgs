{ stdenv, fetchurl, texlive, bison, flex
, gmp, mpfr, pari, ntl, gsl, blas, mpfi, liblapackWithAtlas
, readline, gettext, libpng, libao, gfortran, perl
, enableGUI ? false, libGLU_combined ? null, xorg ? null, fltk ? null
}:

assert enableGUI -> libGLU_combined != null && xorg != null && fltk != null;

stdenv.mkDerivation rec {
  name = "${attr}-${version}";
  attr = if enableGUI then "giac-with-xcas" else "giac";
  version = "1.4.9-59";

  src = fetchurl {
    url = "https://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/giac_${version}.tar.gz";
    sha256 = "0dv5p5y6gkrsmz3xa7fw87rjyabwdwk09mqb09kb7gai9n9dgayk";
  };

  postPatch = ''
    for i in doc/*/Makefile*; do
      substituteInPlace "$i" --replace "/bin/cp" "cp";
    done;
  '';

  nativeBuildInputs = [
    texlive.combined.scheme-small bison flex
  ];

  # perl is only needed for patchShebangs fixup.
  buildInputs = [
    gmp mpfr pari ntl gsl blas mpfi liblapackWithAtlas
    readline gettext libpng libao perl
    # gfortran.cc default output contains static libraries compiled without -fPIC
    # we want libgfortran.so.3 instead
    (stdenv.lib.getLib gfortran.cc)
  ] ++ stdenv.lib.optionals enableGUI [
    libGLU_combined fltk xorg.libX11
  ];

  outputs = [ "out" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" "bindnow" "relro" ];

  configureFlags = [
    "--enable-gc" "--enable-png" "--enable-gsl" "--enable-lapack"
    "--enable-pari" "--enable-ntl" "--enable-gmpxx" # "--enable-cocoa"
    "--enable-ao"
  ] ++ stdenv.lib.optionals enableGUI [
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
    maintainers = [ maintainers.symphorien ];
  };
}
