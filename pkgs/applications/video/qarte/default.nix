{ mkDerivation, lib, fetchbzr, python3, rtmpdump }:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pyqt5_with_qtmultimedia ]);
in mkDerivation {
  pname = "qarte";
  version = "4.14.0";

  src = fetchbzr {
    url = "http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/qarte-4";
    rev = "56";
    sha256 = "sha256-UXRHSVrIZ1JpgSMguNkiDNUNluYpvkF4L4TmR8BrCTM=";
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

  meta = with lib; {
    homepage = "https://launchpad.net/qarte";
    description = "A recorder for Arte TV Guide and Arte Concert";
    license = licenses.gpl3;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
  };
}
