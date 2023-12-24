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

  cargoSha256 = "5vbv4w17DdaTKuF3vQOfv74I8hp2Zpsp40ZlF08qWlc=";

  meta = with lib; {
    description = "A network monitor using bpf";
    homepage = "https://github.com/ZingerLittleBee/netop";
    changelog = "https://github.com/ZingerLittleBee/netop/raw/v${version}/CHANGELOG.md";
    platforms = platforms.linux;
    mainProgram = "netop";
    license = licenses.mit;
    maintainers = [ maintainers.marcusramberg ];
  };
}
