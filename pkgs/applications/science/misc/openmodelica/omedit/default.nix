{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qmake, qttools, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns, omcompiler, omplot,
xorg, git, bash, gtk2, makeWrapper, symlinkJoin, autoreconfHook, lsb-release }:

mkDerivation rec {
  pname = "omedit";
  version = "1.17.0";
  src = fetchgit (import ./src-main.nix);

  nativeBuildInputs = [autoconf automake libtool cmake qttools gfortran clang makeWrapper
    flex bison doxygen
    pkgconfig file
    autoreconfHook lsb-release];

  buildInputs = [hwloc curl
    jre openblas hdf5 expat ncurses readline qtbase qtwebkit webkit which lp_solve
    omniorb sqlite libatomic_ops gettext boost
    ipopt libuuid qtxmlpatterns omhome
    openscenegraph gnome2.gtkglext xorg.libXmu git gtk2 makeWrapper];

  hardeningDisable = [ "format" ];

  omhome = symlinkJoin {
    name = "omedithome";
    paths = [ omcompiler.out omplot.out ];
  };

  enableParallelBuilding = false;

  preAutoreconf = ''
    cd OMEdit
    patchShebangs --build
  '';

  configureFlags = "--with-openmodelicahome=${omhome}";

  patchPhase = ''
    sed -i ''$(find -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
  '';

  dontUseCmakeConfigure = true;

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --prefix PATH : "${gnumake}/bin" \
        --prefix LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ openblas ]}"
    done
  '';

  bowlup = ''
    unpackPhase
    cd OpenModelica-08fd3f9
    eval "$patchPhase"
    autoreconfPhase
    configurePhase
  '';

  meta = with lib; {
    description = "An open-source Modelica-based modeling and simulation environment";
    homepage    = "https://openmodelica.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.linux;
  };
}
