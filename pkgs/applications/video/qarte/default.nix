{ stdenv, fetchbzr, python3, rtmpdump, makeWrapper }:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyqt5 sip ]);
in stdenv.mkDerivation {
  name = "qarte-3.2.0";
  src = fetchbzr {
    url = http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/qarte-3;
    rev = "146";
    sha256 = "0dvl38dknmnj2p4yr25p88kw3mh502c6qdp2bd43bhd2sqc3b0v0";
  };

  buildInputs = [ makeWrapper pythonEnv ];

  installPhase = ''
    mkdir -p $out/bin
    mv qarte $out/bin/
    substituteInPlace $out/bin/qarte \
      --replace '/usr/share' "$out/share"
    wrapProgram $out/bin/qarte \
      --prefix PATH : "${rtmpdump}/bin"

    mkdir -p $out/share/man/man1/
    mv qarte.1 $out/share/man/man1/

    mkdir -p $out/share/qarte
    mv * $out/share/qarte/
  '';

  meta = {
    homepage = https://launchpad.net/qarte;
    description = "A recorder for Arte TV Guide and Arte Concert";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = stdenv.lib.platforms.linux;
  };
}
