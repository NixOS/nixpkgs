{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-afceWAmVpY0x3eXXhQ5unXWNvatiEfqGUwf2lRHTYf8=";
  };

  cargoHash = "sha256-8wleYN0sAgwm0aFsmbwfFw6JEtSYgvKbwkv92LZR5rg=";

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
  };
}
