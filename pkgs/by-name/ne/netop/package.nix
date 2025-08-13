{
  lib,
  libpcap,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "netop";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ZingerLittleBee";
    repo = "netop";
    rev = "v${version}";
    hash = "sha256-Rnp2VNAi8BNbKqkGFoYUb4C5db5BS1P1cqpWlroTmdQ=";
  };

  LIBPCAP_LIBDIR = lib.makeLibraryPath [ libpcap ];
  LIBPCAP_VER = libpcap.version;

  cargoHash = "sha256-WGwtRMARwRvcUflN3JYL32aib+IG1Q0j0D9BEfaiME4=";

  meta = {
    changelog = "https://github.com/ZingerLittleBee/netop/raw/v${version}/CHANGELOG.md";
    description = "Network monitor using bpf";
    homepage = "https://github.com/ZingerLittleBee/netop";
    license = lib.licenses.mit;
    mainProgram = "netop";
    maintainers = [ lib.maintainers.marcusramberg ];
    platforms = lib.platforms.linux;
  };
}
