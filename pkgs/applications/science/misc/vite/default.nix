<<<<<<< HEAD
{ stdenv, fetchFromGitLab, lib, cmake, qtbase, qttools, qtcharts, libGLU, libGL, glm, glew, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "vite";
  version = "unstable-2022-05-17";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "solverstack";
    repo = pname;
    rev = "6d497cc519fac623e595bd174e392939c4de845c";
    hash = "sha256-Yf2jYALZplIXzVtd/sg6gzEYrZ+oU0zLG1ETd/hiTi0=";
  };

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];
  buildInputs = [ qtbase qtcharts libGLU libGL glm glew ];
=======
{ fetchsvn, lib, stdenv, cmake, qt4, libGLU, libGL }:

# ViTE 1.1 has several bugs, so use the SVN version.
let
  rev = "1543";
  externals = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/externals";
    sha256 = "1a422n3dp72v4visq5b1i21cf8sj12903sgg5v2hah3sgk02dnyz";
    inherit rev;
  };
in
stdenv.mkDerivation {
  pname = "vite";
  version = "1.2pre${rev}";

  src = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/trunk";
    sha256 = "02479dv96h29d0w0svp42mjjrxhmv8lkkqp30w7mlx5gr2g0v7lf";
    inherit rev;
  };

  preConfigure = ''
    rm -rv externals
    ln -sv "${externals}" externals
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 libGLU libGL ];

  NIX_LDFLAGS = "-lGLU";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Visual Trace Explorer (ViTE), a tool to visualize execution traces";

    longDescription = ''
      ViTE is a trace explorer. It is a tool to visualize execution
      traces in Pajé or OTF format for debugging and profiling
      parallel or distributed applications.
    '';

    homepage = "http://vite.gforge.inria.fr/";
    license = lib.licenses.cecill20;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
