{ fetchsvn, stdenv, cmake, qt4, mesa }:

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
  name = "vite-1.2pre${rev}";

  src = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/trunk";
    sha256 = "02479dv96h29d0w0svp42mjjrxhmv8lkkqp30w7mlx5gr2g0v7lf";
    inherit rev;
  };

  preConfigure = ''
    rm -rv externals
    ln -sv "${externals}" externals
  '';

  buildInputs = [ cmake qt4 mesa ];

  NIX_LDFLAGS = "-lGLU";

  meta = {
    description = "Visual Trace Explorer (ViTE), a tool to visualize execution traces";

    longDescription = ''
      ViTE is a trace explorer. It is a tool to visualize execution
      traces in Pajé or OTF format for debugging and profiling
      parallel or distributed applications.
    '';

    homepage = http://vite.gforge.inria.fr/;
    license = stdenv.lib.licenses.cecill20;
    maintainers = with stdenv.lib.maintainers; [ ludo fuuzetsu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
