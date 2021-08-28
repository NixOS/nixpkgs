{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0av3v31fvanvn59bdm9d0v9zh5lzrq0f4vqhg6xlvabkgsa8jk04";
  };

  cargoPatches = [
    ./cargo.lock.patch
  ];

  cargoSha256 = "0kfm1pq22dhiw138bf7jvf7amlkal90n1hc9fq44wr4chr9b2fmx";

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
