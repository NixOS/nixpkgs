{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  bluez,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "cwiid";
  version = "unstable-2010-02-21";

  src = fetchFromGitHub {
    owner = "abstrakraft";
    repo = "cwiid";
    rev = "fadf11e89b579bcc0336a0692ac15c93785f3f82";
    sha256 = "0qdb0x757k76nfj32xc2nrrdqd9jlwgg63vfn02l2iznnzahxp0h";
  };

  hardeningDisable = [ "format" ];

  configureFlags = [ "--without-python" ];

  prePatch = ''
    sed -i -e '/$(LDCONFIG)/d' common/include/lib.mak.in
  '';

  patches = [
    ./fix-ar.diff
  ];

  buildInputs = [
    bluez
    gtk2
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    bison
    flex
  ];

  NIX_LDFLAGS = "-lbluetooth";

  postInstall = ''
    # Some programs (for example, cabal-install) have problems with the double 0
    sed -i -e "s/0.6.00/0.6.0/" $out/lib/pkgconfig/cwiid.pc
  '';

  meta = with lib; {
    description = "Linux Nintendo Wiimote interface";
    homepage = "http://cwiid.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.linux;
  };
}
