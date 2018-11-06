{ stdenv, fetchFromGitHub
, libusb1, systemd }:

stdenv.mkDerivation rec {
  name = "dmrconfig-${version}";
  version = "2018-10-29";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = "4924d00283c3c81a4b8251669e42aecd96b6145a";
    sha256 = "00a4hmbr71g0d4faskb8q96y6z212g2r4n533yvp88z8rq8vbxxn";
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
