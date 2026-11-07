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
  withWiresharkDissector ? false,
  wireshark,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kronosnet";
  version = "1.35";

  src = fetchFromGitHub {
    owner = "kronosnet";
    repo = "kronosnet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dlokVXqm1U9tt7/X07TQ7076yYXVjarHq01+R3sqCJM=";
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
  ]
  ++ lib.optionals withWiresharkDissector [
    wireshark
    glib
  ];

  configureFlags = [
    (lib.enableFeature withWiresharkDissector "wireshark-dissector")
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
