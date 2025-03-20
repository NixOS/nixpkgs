{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-careful";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${version}";
    hash = "sha256-pYfyqsS+bGwSP6YZAtI+8iMXdID/hrCiX+cuYoYiZmc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hb3x2LKtDNAhMbRCB3kAwHloFTojGzQdXsMjxeJYB6k=";

  meta = with lib; {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
