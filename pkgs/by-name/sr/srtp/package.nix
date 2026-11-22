{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  meson,
  ninja,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libsrtp";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "sha256-kLuz3gPVDhm1fzcrXL4xky+hrTprJbcxgQCyb4nVThQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpcap
    openssl
  ];

  # rtpw tests hang
  preConfigure = ''
    rm test/rtpw_test.sh \
       test/rtpw_test_gcm.sh
  '';

  mesonFlags = [
    "-Dcrypto-library=openssl"
    "-Dcrypto-library-kdf=disabled"
    "-Ddoc=disabled"
    "-Dtests=${if doCheck then "enabled" else "disabled"}"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/cisco/libsrtp";
    description = "Secure RTP (SRTP) Reference Implementation";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ r-burns ];
  };
}
