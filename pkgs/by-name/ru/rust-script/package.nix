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
    repo = pname;
    rev = version;
    sha256 = "sha256-uKmQgrbsFIY0XwrO16Urz3L76Gm2SxHW/CpHeCIUinM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eSj04d/ktabUm58C7PAtiPqdiVP9NB3uSFxILZxe6jA=";

  # tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    mainProgram = "rust-script";
    homepage = "https://rust-script.org";
    changelog = "https://github.com/fornwall/rust-script/releases/tag/${version}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
