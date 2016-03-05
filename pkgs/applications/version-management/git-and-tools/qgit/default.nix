{stdenv, fetchurl, qt, libXext, libX11}:

stdenv.mkDerivation rec {
  name = "qgit-2.5";

  src = fetchurl {
    url = "http://libre.tibirna.org/attachments/download/9/${name}.tar.gz";
    sha256 = "25f1ca2860d840d87b9919d34fc3a1b05d4163671ed87d29c3e4a8a09e0b2499";
  };

  buildInputs = [qt libXext libX11];

  hardeningDisable = [ "format" ];

  configurePhase = "qmake PREFIX=$out";

  installPhase = ''
    install -s -D -m 755 bin/qgit "$out/bin/qgit"
  '';

  meta = {
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://libre.tibirna.org/projects/qgit/wiki/QGit";
    description = "Graphical front-end to Git";
    inherit (qt.meta) platforms;
  };
}
