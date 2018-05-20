{ stdenv, fetchurl, cups, libssh, libXpm, nxproxy, openldap, openssh, makeWrapper, qt4 }:

stdenv.mkDerivation rec {
  name = "x2goclient-${version}";
  version = "4.1.1.1";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/x2goclient/${name}.tar.gz";
    sha256 = "0jzlwn0v8b123h5l7hrhs35x2z6mb98zg1s0shqb4yfp2g641yp3";
  };

  buildInputs = [ cups libssh libXpm nxproxy openldap openssh qt4 ];
  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
     substituteInPlace Makefile \
       --replace "SHELL=/bin/bash" "SHELL=$SHELL" \
       --replace "lrelease-qt4" "${qt4}/bin/lrelease" \
       --replace "qmake-qt4" "${qt4}/bin/qmake" \
       --replace "-o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "ETCDIR=$(out)/etc" ];

  enableParallelBuilding = true;

  installTargets = [ "install_client" "install_man" ];
  postInstall = ''
    wrapProgram "$out/bin/x2goclient" --suffix PATH : "${nxproxy}/bin:${openssh}/libexec";
  '';

  meta = with stdenv.lib; {
    description = "Graphical NoMachine NX3 remote desktop client";
    homepage = http://x2go.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
