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
  version = "1.32";

  src = fetchFromGitHub {
    owner = "kronosnet";
    repo = "kronosnet";
    rev = "v${version}";
    sha256 = "sha256-6W8b5M97L1KxissLJej67v1+OhB7Pm+qLDSpjp8PF4c=";
  };

  # Fix autoreconf issue: libtool puts ltmain.sh in ../../ but automake expects ./
  preAutorreconf = ''
    # Run libtollize first to generate ltmain.sh in the correct location
    libtoolize --copy --force --install
    # Now copy ltmain.sh to where automake expects it
    if [ -f ../../ltmain.sh ]; then
      cp ../../ltmain.sh ./ltmain.sh
    fi
  '';

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
}
