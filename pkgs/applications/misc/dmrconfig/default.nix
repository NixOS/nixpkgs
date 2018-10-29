{ stdenv, fetchFromGitHub
, libusb1, systemd }:

stdenv.mkDerivation rec {
  name = "dmrconfig-${version}";
  version = "2018-10-20";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = "a4c5f893d2749727493427320c7f01768966ba51";
    sha256 = "0h7hv6fv6v5g922nvgrb0w7hsqbhaw7xmdc6vydh2p3l7sp31vg2";
  };

  buildInputs = [
    libusb1 systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig
  '';

  preInstall = ''
    mkdir -p $out/bin
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
