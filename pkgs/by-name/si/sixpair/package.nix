{
  lib,
  stdenv,
  fetchurl,
  libusb-compat-0_1,
}:
stdenv.mkDerivation {
  pname = "sixpair";
  version = "unstable-2007-04-18";

  src = fetchurl {
    url = "http://www.pabr.org/sixlinux/sixpair.c";
    sha256 = "1b0a3k7gs544cbji7n29jxlrsscwfx6s1r2sgwdl6hmkc1l9gagr";
  };

  # hcitool is deprecated
  patches = [ ./hcitool.patch ];

  buildInputs = [ libusb-compat-0_1 ];

  unpackPhase = ''
    cp $src sixpair.c
  '';

  buildPhase = ''
    cc -o sixpair sixpair.c -lusb
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sixpair $out/bin/sixpair
  '';

  meta = {
    description = "Pair with SIXAXIS controllers over USB";
    longDescription = ''
      This command-line utility searches USB buses for SIXAXIS controllers and tells them to connect to a new Bluetooth master.
    '';
    homepage = "http://www.pabr.org/sixlinux/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.tomsmeets ];
    platforms = lib.platforms.linux;
    mainProgram = "sixpair";
  };
}
