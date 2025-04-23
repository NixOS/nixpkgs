{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.16";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-cz0lyBrAOi1gAIXsoe/KAk8W5wzHmq4N187FI3imV+Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m6CFu0HA4e/9hWgYcRPjfa0h5vk0zwt5PqgvsuJuPNk=";

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
