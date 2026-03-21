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

stdenv.mkDerivation (finalAttrs: {
  pname = "kronosnet";
  version = "1.32";

  src = fetchFromGitHub {
    owner = "kronosnet";
    repo = "kronosnet";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-6W8b5M97L1KxissLJej67v1+OhB7Pm+qLDSpjp8PF4c=";
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

  meta = {
    description = "VPN on steroids";
    homepage = "https://kronosnet.org/";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ ryantm ];
  };
})
