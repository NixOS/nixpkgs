{stdenv, fetchFromGitHub, cmake
,full, python, mesa, libXt }:

stdenv.mkDerivation rec {
  name = "paraview-${version}";
  version = "5.4.0";

  # fetching from GitHub instead of taking an "official" source
  # tarball because of missing submodules there
  src = fetchFromGitHub {
    owner = "Kitware";
    repo = "ParaView";
    rev = "v${version}";
    sha256 = "0h1vkgwm10mc5mnr3djp81lxr5pi0hyj776z77hiib6xm5596q9n";
    fetchSubmodules = true;
  };

   cmakeFlags = [
     "-DPARAVIEW_ENABLE_PYTHON=ON"
     "-DPARAVIEW_INSTALL_DEVELOPMENT_FILES=ON"
   ];

  # During build, binaries are called that rely on freshly built
  # libraries.  These reside in build/lib, and are not found by
  # default.
  preBuild = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
  '';

  enableParallelBuilding = true;

  buildInputs = [ cmake
   python
   mesa
   libXt

   # theoretically the following should be fine, but there is an error
   # due to missing libqminimal when not using qt5.full

   # qtbase qtx11extras qttools
   full
   ];


  meta = {
    homepage = http://www.paraview.org/;
    description = "3D Data analysis and visualization application";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric guibert];
    platforms = with stdenv.lib.platforms; linux;
  };
}
