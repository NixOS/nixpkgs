{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = "rust-script";
    rev = version;
    sha256 = "sha256-Bb8ULD2MmZiSW/Tx5vAAHv95OMJ0EdWgR+NFhBkTlDU=";
  };

  cargoHash = "sha256-kxnylNZ8FsaR2S1o/p7qtlaXsBLDNv2PsFye0rcf/+A=";

  # tests require network access
  doCheck = false;

  meta = {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    mainProgram = "rust-script";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/releases/tag/${version}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
