{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, ldns
, libck
, nghttp2
, openssl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "dnsperf";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    hash = "sha256-eDDVNFMjj+0wEBe1qO6r4Bai554Sp+EmP86reJ/VXGk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ldns # optional for DDNS (but cheap anyway)
    libck
    nghttp2
    openssl
  ];

  doCheck = true;

  meta = with lib; {
    description = "Tools for DNS benchmaring";
    homepage = "https://www.dns-oarc.net/tools/dnsperf";
    changelog = "https://github.com/DNS-OARC/dnsperf/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.unix;
    mainProgram = "dnsperf";
    maintainers = with maintainers; [ vcunat mfrw ];
  };
}
