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
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-R+DlhRZOwL/hBZAu4L7w7DAoHy1/1m8wsidSxByO74E=";
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
