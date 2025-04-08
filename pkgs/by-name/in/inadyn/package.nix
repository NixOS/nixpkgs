{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gnutls,
  libite,
  libconfuse,
}:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-aQHJtnMDaHF1XY9lwQVR6f78Zk2UI7OC3Oxt1r1KMak=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gnutls
    libite
    libconfuse
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/projects/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "inadyn";
  };
}
