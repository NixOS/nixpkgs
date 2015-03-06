{ fetchurl, stdenv, nxproxy, qt4, openldap, libssh, libXpm, cups, makeWrapper }:

stdenv.mkDerivation rec {
  version = "4.0.3.1";
  name = "x2goclient-${version}";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/x2goclient/x2goclient-4.0.3.1.tar.gz";
    md5 = "ef9a20ef96f7c31cc20ece9ebbf1e007";
  };


  buildInputs = [ nxproxy qt4 openldap libssh libXpm cups makeWrapper ];

  preBuild = ''
    lrelease x2goclient.pro;
    qmake;
  '';
  postInstall = ''
    mkdir -p $out/bin;
    cp x2goclient $out/bin;
    cp -a man $out;
    wrapProgram "$out/bin/x2goclient" --suffix PATH : "${nxproxy}/bin";
  '';
  meta = {
    homepage = "http://x2go.org/";
    license = stdenv.lib.licenses.gpl2;
    description = "A graphical remote desktop client utilizing NoMachine's NX3 technology";
    platforms = stdenv.lib.platforms.linux;
  };
}
