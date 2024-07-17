{
  mkDerivation,
  lib,
  fetchbzr,
  python3,
  rtmpdump,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      m3u8
      pyqt5-multimedia
    ]
  );
in
mkDerivation {
  pname = "qarte";
  version = "5.5.0";

  src = fetchbzr {
    url = "http://bazaar.launchpad.net/~vincent-vandevyvre/qarte/qarte-5";
    rev = "88";
    sha256 = "sha256-+Ixe4bWKubH/XBESwmP2NWS8bH0jq611c3MZn7W87Jw=";
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
    description = "Recorder for Arte TV Guide and Arte Concert";
    license = licenses.gpl3;
    maintainers = with maintainers; [ vbgl ];
    platforms = platforms.linux;
    mainProgram = "qarte";
  };
}
