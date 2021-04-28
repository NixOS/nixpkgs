{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qmake, qttools, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook }:

let omrepo = import ./src-main.nix;
in
mkDerivation rec {
  pname = "omcompiler";
  version = "1.17.0";
  src = fetchgit omrepo;

  nativeBuildInputs = [autoconf automake libtool cmake qttools gfortran clang makeWrapper
    flex bison doxygen
    pkgconfig file
    autoreconfHook];

  buildInputs = [hwloc curl
    jre openblas hdf5 expat ncurses readline qtbase qtwebkit webkit which lp_solve
    omniorb sqlite libatomic_ops gettext boost
    ipopt libuuid qtxmlpatterns
    openscenegraph gnome2.gtkglext xorg.libXmu git gtk2 makeWrapper];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = false;

  #sourceRoot = "OpenModelica-" + builtins.substring 0 7 omrepo.rev + "/OMCompiler";
  preAutoreconf = "cd OMCompiler";
  patchPhase = ''
    sed -i ''$(find -L -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    sed -i OMCompiler/Makefile.common -e '/INSTALL_LOCALEDIR/ s|^|#|'
  '';

  dontUseCmakeConfigure = true;

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --prefix PATH : "${gnumake}/bin" \
        --prefix LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ openblas ]}"
    done
  '';

  meta = with lib; {
    description = "An open-source Modelica-based modeling and simulation environment";
    homepage    = "https://openmodelica.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.linux;
  };
}
