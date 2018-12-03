{ stdenv, fetchFromGitHub
, libusb1, systemd }:

stdenv.mkDerivation rec {
  name = "dmrconfig-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = version;
    sha256 = "1bb3hahfdb5phxyzp1m5ibqwz3mcqplzaibb1aq7w273xcfrd9l9";
  };

  buildInputs = [
    libusb1 systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig \
      --replace "\$(shell git describe --tags --abbrev=0)" ${version} \
      --replace "\$(shell git rev-list HEAD --count)" 0
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
