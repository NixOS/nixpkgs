{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.17";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-bEsBLihMqYHJa5913Q434xKVufxTrcaxwcANPV9u37U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ob4UuBLD6HFbghv4E2XMj+xVeUSFtc9qPUNuUDgZeQA=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aiken";
  };
}
