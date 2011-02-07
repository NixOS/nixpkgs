{ stdenv, fetchurl, clisp }:

let
    name    = "maxima";
    version = "5.23.2";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
  };

  preConfigure = ''
    configureFlags="--infodir=$out/share/info --mandir=$out/share/man"
  '';

  buildInputs = [clisp];

  meta = {
    description = "Maxima computer algebra system";
    homepage = "http://maxima.sourceforge.net";
    license = "GPLv2";

    longDescription = ''
      Maxima is a fairly complete computer algebra system written in
      lisp with an emphasis on symbolic computation. It is based on
      DOE-MACSYMA and licensed under the GPL. Its abilities include
      symbolic integration, 3D plotting, and an ODE solver.
    '';

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
