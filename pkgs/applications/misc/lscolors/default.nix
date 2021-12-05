{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "lscolors";
  version = "0.8.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-74KNnERhyiZamVyS9yzDNVf33KMqDiSfPb5BCTKFuHA=";
  };

  cargoSha256 = "sha256-mjGZ/q9BByndwfnFGk6k5KD9ctY0X0/oaEugiOJY8Ms=";

  # setid is not allowed in the sandbox
  checkFlags = [ "--skip=tests::style_for_setid" ];

  meta = with lib; {
    description = "Rust library and tool to colorize paths using LS_COLORS";
    homepage = "https://github.com/sharkdp/lscolors";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
