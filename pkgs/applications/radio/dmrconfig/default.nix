{ stdenv, fetchFromGitHub
, libusb1, systemd }:

stdenv.mkDerivation rec {
  name = "dmrconfig-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = version;
    sha256 = "1qwix75z749628w583fwp7m7kxbj0k3g159sxb7vgqxbadqqz1ab";
  };

  buildInputs = [
    libusb1 systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig
  '';

  makeFlags = "VERSION=${version} GITCOUNT=0";

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
