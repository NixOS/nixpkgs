{ fetchsvn, stdenv, cmake, qt4, mesa }:

# ViTE 1.1 has several bugs, so use the SVN version.
let
  rev = "1143";
  externals = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/externals";
    sha256 = "0wg3yh5q8gx7189rvkd8achld7bzp0i7qqn6c77pg767b4b8dh1a";
    inherit rev;
  };
in
stdenv.mkDerivation {
  name = "vite-1.2pre${rev}";

  src = fetchsvn {
    url = "svn://scm.gforge.inria.fr/svn/vite/trunk";
    sha256 = "0cy9b6isiwqwnv9gk0cg97x370fpwyccljadds4a118k5gh58zw4";
    inherit rev;
  };

  preConfigure =
    '' rm -v externals
       ln -sv "${externals}" externals
    '';

  patches = [ ./larger-line-buffer.patch ];

  buildInputs = [ cmake qt4 mesa ];

  NIX_LDFLAGS = "-lGLU";

  meta = {
    description = "Visual Trace Explorer (ViTE), a tool to visualize execution traces";

    longDescription =
      '' ViTE is a trace explorer. It is a tool to visualize execution traces
         in Pajé or OTF format for debugging and profiling parallel or
         distributed applications.
      '';

    homepage = http://vite.gforge.inria.fr/;

    license = "CeCILL-A";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice

    broken = true;
  };
}
