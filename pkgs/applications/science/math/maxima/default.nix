{ stdenv, fetchurl, clisp }:

let
    name    = "maxima";
    version = "5.22.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "0sdrv3lra6j3ylaqsblnd3x7rq4ybafyj7rb114ycadpx2qf06lq";
  };

  buildInputs = [clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = "http://maxima.sourceforge.net";

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
