{ stdenv, fetchurl, clisp, texinfo, perl }:

let
  name    = "maxima";
  version = "5.24.0";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-${version}.tar.gz";
    sha256 = "137crv2f6hxwqrv75m8679vrlbnqgg5ww755cs4kihs1cy03bssq";
  };

  preConfigure = ''
    configureFlags="--infodir=$out/share/info --mandir=$out/share/man"
  '';

  buildInputs = [clisp texinfo perl];

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
