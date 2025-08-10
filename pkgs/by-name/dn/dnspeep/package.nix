{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libpcap,
}:

rustPlatform.buildRustPackage rec {
  pname = "dnspeep";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jvns";
    repo = "dnspeep";
    rev = "v${version}";
    sha256 = "sha256-QpUbHiMDQFRCTVyjrO9lfQQ62Z3qanv0j+8eEXjE3n4=";
  };

  cargoHash = "sha256-tZlh7+END6oOy3uWOrjle+nwqFhMU6bbXmr4hdt6gqY=";

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  meta = with lib; {
    description = "Spy on the DNS queries your computer is making";
    mainProgram = "dnspeep";
    homepage = "https://github.com/jvns/dnspeep";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
