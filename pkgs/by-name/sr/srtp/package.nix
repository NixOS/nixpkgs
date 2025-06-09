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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = "libsrtp";
    rev = "v${version}";
    sha256 = "sha256-5AFsigie3YUrfvZYEIopjBJSNdoKoFlMBP9lv68+f6Q=";
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

  meta = with lib; {
    homepage = "https://github.com/cisco/libsrtp";
    description = "Secure RTP (SRTP) Reference Implementation";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ r-burns ];
  };
}
