{ stdenv, lib, fetchurl, fetchpatch, texlive, bison, flex, lapack, blas
, autoreconfHook, gmp, mpfr, pari, ntl, gsl, mpfi, ecm, glpk, nauty
, buildPackages, readline, gettext, libpng, libao, gfortran, perl
, enableGUI ? false, libGL, libGLU, xorg, fltk
, enableMicroPy ? false, python3
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "giac${lib.optionalString enableGUI "-with-xcas"}";
  version = "1.9.0-5"; # TODO try to remove preCheck phase on upgrade

  src = fetchurl {
    url = "https://www-fourier.ujf-grenoble.fr/~parisse/debian/dists/stable/main/source/giac_${version}.tar.gz";
    sha256 = "sha256-EP8wRi8QZPrr1lfKN6da87s1FCy8AuDYbzcvsJCWyLE=";
  };

  patches = [
    (fetchpatch {
      name = "pari_2_11.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/giac/patches/pari_2_11.patch?id=21ba7540d385a9864b44850d6987893dfa16bfc0";
      sha256 = "sha256-vEo/5MNzMdYRPWgLFPsDcMT1W80Qzj4EPBjx/B8j68k=";
    })
  ] ++ lib.optionals (!enableGUI) [
    # when enableGui is false, giac is compiled without fltk. That
    # means some outputs differ in the make check. Patch around this:
    (fetchpatch {
      name = "nofltk-check.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/giac/patches/nofltk-check.patch?id=7553a3c8dfa7bcec07241a07e6a4e7dcf5bb4f26";
      sha256 = "0xkmfc028vg5w6va04gp2x2iv31n8v4shd6vbyvk4blzgfmpj2cw";
    })
  ];

  # 1.9.0-5's tarball contains a binary (src/mkjs) which is executed
  # at build time. we will delete and rebuild it.
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch = ''
    for i in doc/*/Makefile* micropython*/xcas/Makefile*; do
      substituteInPlace "$i" --replace "/bin/cp" "cp";
    done;
    rm src/mkjs
    substituteInPlace src/Makefile.am --replace "g++ mkjs.cc" \
      "${buildPackages.stdenv.cc.targetPrefix}c++ mkjs.cc"

    # to open help
    substituteInPlace src/global.cc --replace 'browser="mozilla"' 'browser="xdg-open"'
  '';

  nativeBuildInputs = [
    autoreconfHook texlive.combined.scheme-small bison flex
  ];

  # perl is only needed for patchShebangs fixup.
  buildInputs = [
    gmp mpfr pari ntl gsl blas mpfi glpk nauty
    readline gettext libpng libao perl ecm
    # gfortran.cc default output contains static libraries compiled without -fPIC
    # we want libgfortran.so.3 instead
    (lib.getLib gfortran.cc)
    lapack blas
  ] ++ lib.optionals enableGUI [
    libGL libGLU fltk xorg.libX11
  ] ++ lib.optional enableMicroPy python3;

  # xcas Phys and Turtle menus are broken with split outputs
  # and interactive use is likely to need docs
  outputs = [ "out" ] ++ lib.optional (!enableGUI) "doc";

  doCheck = true;
  preCheck = lib.optionalString (!enableGUI) ''
    # even with the nofltk patch, some changes in src/misc.cc (grep
    # for HAVE_LIBFLTK) made it so that giac behaves differently
    # when fltk is disabled. disable these tests for now.
    echo > check/chk_fhan2
    echo > check/chk_fhan9
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-gc" "--enable-png" "--enable-gsl" "--enable-lapack"
    "--enable-pari" "--enable-ntl" "--enable-gmpxx" # "--enable-cocoa"
    "--enable-ao" "--enable-ecm" "--enable-glpk"
  ] ++ lib.optionals enableGUI [
    "--enable-gui" "--with-x"
  ] ++ lib.optional (!enableMicroPy) "--disable-micropy";

  postInstall = ''
    # example Makefiles contain the full path to some commands
    # notably texlive, and we don't want texlive to become a runtime
    # dependency
    for file in $(find $out -name Makefile) ; do
      sed -i "s@/nix/store/[^/]*/bin/@@" "$file" ;
    done;

    # reference cycle
    rm "$out/share/giac/doc/el/"{casinter,tutoriel}/Makefile

    if [ -n "$doc" ]; then
      mkdir -p "$doc/share/giac"
      mv "$out/share/giac/doc" "$doc/share/giac"
      mv "$out/share/giac/examples" "$doc/share/giac"
    fi
  '' + lib.optionalString (!enableGUI) ''
    for i in pixmaps application-registry applications icons; do
      rm -r "$out/share/$i";
    done;
  '';

  meta = with lib; {
    description = "A free computer algebra system (CAS)";
    homepage = "https://www-fourier.ujf-grenoble.fr/~parisse/giac.html";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ (optionals (!enableGUI) platforms.darwin);
    maintainers = [ maintainers.symphorien ];
  };
}
