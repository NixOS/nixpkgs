{ mkDerivation, lib, fetchbzr, python3, rtmpdump }:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyqt5_with_qtmultimedia ]);
in mkDerivation {
  name = "qarte-4.6.0";
  src = fetchbzr {
    url = http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/qarte-4;
    rev = "22";
    sha256 = "0v4zpj8w67ydvnmanxbl8pwvn0cfv70c0mlw36a1r4n0rvgxffcn";
  };

  buildInputs = [ pythonEnv ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv qarte $out/bin/
    substituteInPlace $out/bin/qarte \
      --replace '/usr/share' "$out/share"

    mkdir -p $out/share/man/man1/
    mv qarte.1 $out/share/man/man1/

    mkdir -p $out/share/qarte
    mv * $out/share/qarte/
    runHook postInstall
  '';

  postFixup = ''
    wrapQtApp $out/bin/qarte \
      --prefix PATH : ${rtmpdump}/bin
  '';

  meta = {
    homepage = https://launchpad.net/qarte;
    description = "A recorder for Arte TV Guide and Arte Concert";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ vbgl ];
    platforms = lib.platforms.linux;
  };
}
