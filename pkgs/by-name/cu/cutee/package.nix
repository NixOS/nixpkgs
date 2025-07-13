{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cutee";
  version = "0.4.2";

  src = fetchurl {
    url = "https://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildFlags = [ "cutee" ];

  installPhase = ''
    mkdir -p $out/bin
    cp cutee $out/bin
  '';

  meta = with lib; {
    description = "C++ Unit Testing Easy Environment";
    mainProgram = "cutee";
    homepage = "https://www.codesink.org/cutee_unit_testing.html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
