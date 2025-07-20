{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = "rust-script";
    rev = version;
    sha256 = "sha256-uKmQgrbsFIY0XwrO16Urz3L76Gm2SxHW/CpHeCIUinM=";
  };

  cargoHash = "sha256-eSj04d/ktabUm58C7PAtiPqdiVP9NB3uSFxILZxe6jA=";

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
