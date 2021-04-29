{stdenv, lib, mkDerivation, fetchFromGitHub, fetchgit, autoconf, automake, libtool,
gfortran, clang, cmake, curl, gnumake, hwloc, jre, openblas, hdf5, expat, ncurses,
readline, qmake, which, lp_solve, omniorb, sqlite, libatomic_ops,
pkgconfig, file, gettext, flex, bison, doxygen, boost, qttools,
ipopt, libuuid, git, bash, makeWrapper, autoreconfHook }:

let omrepo = import ./src-main.nix;
in
mkDerivation rec {
  pname = "omcompiler";
  version = "1.17.0";
  src = fetchgit omrepo;

  nativeBuildInputs = [autoconf automake libtool cmake gfortran clang makeWrapper
    flex bison doxygen qttools
    pkgconfig file
    autoreconfHook];

  buildInputs = [hwloc curl
    jre openblas hdf5 expat ncurses readline which lp_solve
    omniorb sqlite libatomic_ops gettext boost
    ipopt libuuid
    git makeWrapper];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = false;

  # sourceRoot = "OpenModelica-" + builtins.substring 0 7 omrepo.rev + "/OMCompiler";
  preAutoreconf = ''
    cd OMCompiler
    patchShebangs --build
  '';

  patchPhase = ''
    sed -i ''$(find -L -name qmake.m4) -e '/^\s*LRELEASE=/ s|LRELEASE=.*$|LRELEASE=${lib.getDev qttools}/bin/lrelease|'
    sed -i OMCompiler/Makefile.common -e '/INSTALL_LOCALEDIR/ s|^|#|'
    sed -i ''$(find -name CMakeLists.txt) -e 's|/''${CMAKE_LIBRARY_ARCHITECTURE}||'
    sed -i ''$(find -name Makefile.in) -e 's|/@host_short@||'
  '';

  dontUseCmakeConfigure = true;

  preFixup = ''
    for entry in $(find $out -regex '.*\.so\.?.*' -type f); do
      patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store $entry
      patchelf --set-rpath '$ORIGIN':"$(patchelf --print-rpath $entry)" $entry
    done
  '';

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
