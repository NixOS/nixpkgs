{ stdenv, fetchurl, cups, libssh, libXpm, nxproxy, openldap, makeWrapper, qt4 }:

stdenv.mkDerivation rec {
  name = "x2goclient-${version}";
  version = "4.0.5.1";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/x2goclient/${name}.tar.gz";
    sha256 = "04gdccqywas029a76k3r9zhr2mfn385i9r06cmi8mznxpczrhkl4";
  };

  buildInputs = [ cups libssh libXpm nxproxy openldap qt4 ];
  nativeBuildInputs = [ makeWrapper ];

  patchPhase = ''
     substituteInPlace Makefile \
       --replace "lrelease-qt4" "${qt4}/bin/lrelease" \
       --replace "qmake-qt4" "${qt4}/bin/qmake" \
       --replace "-o root -g root" ""
  '';

  makeFlags = [ "PREFIX=$(out)" "ETCDIR=$(out)/etc" ];

  enableParallelBuilding = true;

  installTargets = [ "install_client" "install_man" ];
  postInstall = ''
    wrapProgram "$out/bin/x2goclient" --suffix PATH : "${nxproxy}/bin";
  '';

  meta = with stdenv.lib; {
    description = "Graphical NoMachine NX3 remote desktop client";
    homepage = http://x2go.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
