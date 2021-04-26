{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qtbase, qmake, qttools, qtwebkit, webkit, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, openscenegraph, gnome2,
ipopt, libuuid, qtxmlpatterns,
xorg, git, bash, gtk2, makeWrapper, autoreconfHook }:

let

  fakegit = import ./fakegit.nix {inherit stdenv fetchgit bash;} ;

in

mkDerivation rec {
  pname = "openmodelica";
  version = "1.13.0";
  src = fetchgit (import ./src-main.nix);

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

  patchPhase = ''
    cp -fv ${fakegit}/bin/checkout-git.sh libraries/checkout-git.sh
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

  meta = with lib; {
    description = "An open-source Modelica-based modeling and simulation environment";
    homepage    = "https://openmodelica.org";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ smironov ];
    platforms   = platforms.linux;
  };
}
