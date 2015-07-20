{ stdenv, fetchurl, cups, libssh, libXpm, nxproxy, openldap, makeWrapper, qt4 }:

let version = "4.0.4.0"; in
stdenv.mkDerivation rec {
  name = "x2goclient-${version}";

  src = fetchurl {
    url = "http://code.x2go.org/releases/source/x2goclient/${name}.tar.gz";
    sha256 = "0mqn4nvq2w7qja5i4vx9fg2spwzl01p0hmfwbjb0mzir03hmrl46";
  };

  meta = with stdenv.lib; {
    description = "Graphical NoMachine NX3 remote desktop client";
    homepage = http://x2go.org/;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
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
}
