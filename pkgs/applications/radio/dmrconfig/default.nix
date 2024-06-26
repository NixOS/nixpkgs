{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libusb1,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "dmrconfig";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "sergev";
    repo = "dmrconfig";
    rev = version;
    sha256 = "1qwix75z749628w583fwp7m7kxbj0k3g159sxb7vgqxbadqqz1ab";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains.
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/OpenRTX/dmrconfig/commit/1a6901488db26262a6b69f80b0e795864e9e8d0a.patch";
      sha256 = "03px1y95a8aspd251i1jj8ggqfjvkqby4lhn5pb7l5c1lzh6h762";
    })
  ];

  buildInputs = [
    libusb1
    systemd
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local/bin/dmrconfig $out/bin/dmrconfig
  '';

  makeFlags = [
    "VERSION=${version}"
    "GITCOUNT=0"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/udev/rules.d
    make install
    install 99-dmr.rules $out/lib/udev/rules.d/99-dmr.rules
  '';

  meta = with lib; {
    description = "Configuration utility for DMR radios";
    longDescription = ''
      DMRconfig is a utility for programming digital radios via USB programming cable.
    '';
    homepage = "https://github.com/sergev/dmrconfig";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "dmrconfig";
  };
}
