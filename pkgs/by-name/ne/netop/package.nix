{ lib, libpcap, rustPlatform, fetchFromGitHub }:

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

  cargoHash = "sha256-5vbv4w17DdaTKuF3vQOfv74I8hp2Zpsp40ZlF08qWlc=";

  meta = with lib; {
    changelog = "https://github.com/ZingerLittleBee/netop/raw/v${version}/CHANGELOG.md";
    description = "Network monitor using bpf";
    homepage = "https://github.com/ZingerLittleBee/netop";
    license = licenses.mit;
    mainProgram = "netop";
    maintainers = [ maintainers.marcusramberg ];
    platforms = platforms.linux;
  };
}
