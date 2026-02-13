{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libpcap,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dnspeep";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jvns";
    repo = "dnspeep";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QpUbHiMDQFRCTVyjrO9lfQQ62Z3qanv0j+8eEXjE3n4=";
  };

  cargoHash = "sha256-tZlh7+END6oOy3uWOrjle+nwqFhMU6bbXmr4hdt6gqY=";

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  meta = {
    description = "Spy on the DNS queries your computer is making";
    mainProgram = "dnspeep";
    homepage = "https://github.com/jvns/dnspeep";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
