{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqb,
  libxml2,
  libnl,
  lksctp-tools,
  nss,
  openssl,
  bzip2,
  lzo,
  lz4,
  xz,
  zlib,
  zstd,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "kronosnet";
  version = "1.31";

  src = fetchFromGitHub {
    owner = "kronosnet";
    repo = "kronosnet";
    rev = "v${version}";
    sha256 = "sha256-PZWaKrCy0S8d/x3GMh7X2wEiHwgiuEFpfCwKpbLvhsc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    doxygen
  ];

  buildInputs = [
    libqb
    libxml2
    libnl
    lksctp-tools
    nss
    openssl
    bzip2
    lzo
    lz4
    xz
    zlib
    zstd
  ];

  meta = with lib; {
    description = "VPN on steroids";
    homepage = "https://kronosnet.org/";
    license = with licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with maintainers; [ ryantm ];
  };
}
