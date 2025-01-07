{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "cutee";
  version = "0.4.2";

  src = fetchurl {
    url = "http://www.codesink.org/download/${pname}-${version}.tar.gz";
    sha256 = "18bzvhzx8k24mpcim5669n3wg9hd0sfsxj8zjpbr24hywrlppgc2";
  };

  buildFlags = [ "cutee" ];

  installPhase = ''
    mkdir -p $out/bin
    cp cutee $out/bin
  '';

  meta = {
    description = "C++ Unit Testing Easy Environment";
    mainProgram = "cutee";
    homepage = "https://www.codesink.org/cutee_unit_testing.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leenaars ];
    platforms = lib.platforms.linux;
  };
}
