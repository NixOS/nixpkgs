{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    tag = "v${version}";
    hash = "sha256-7MPNs2vAzCo5TPJZFhd3xaZW0YbF724gfKNLB08IU8A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eWox5NrvZr+mEGGwxYbAW5EgEOQ8WQUy2pughBlpXgM=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    changelog = "https://github.com/LucasPickering/slumber/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
