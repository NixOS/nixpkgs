{ stdenv, fetchFromGitHub
, libusb1, systemd }:

stdenv.mkDerivation rec {
  name = "dmrconfig-${version}";
  version = "2018-11-07";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = "b58985d3c848b927e91699d97f96d9de014c3fc7";
    sha256 = "083f21hz6vqjpndkn27nsjnhnc5a4bw0cr26ryfqcvz275rj4k18";
  };

  buildInputs = [
    libusb1 systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib/udev/rules.d
    make install
    install 99-dmr.rules $out/lib/udev/rules.d/99-dmr.rules
  '';

  meta = with stdenv.lib; {
    description = "Configuration utility for DMR radios";
    longDescription = ''
      DMRconfig is a utility for programming digital radios via USB programming cable.
    '';
    homepage = https://github.com/sergev/dmrconfig;
    license = licenses.asl20;
    maintainers = [ maintainers.etu ];
    platforms = platforms.linux;
  };
}
