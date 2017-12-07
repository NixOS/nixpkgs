{ stdenv, fetchbzr, python3, rtmpdump, makeWrapper }:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyqt5 sip ]);
in stdenv.mkDerivation {
  name = "qarte-3.10.0+188";
  src = fetchbzr {
    url = http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/qarte-3;
    rev = "188";
    sha256 = "06xpkjgm5ci5gfkza9f44m8l4jj32gfmr65cqs4x0j2ihrc6b4r9";
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
