{ lib
, rustPlatform
, fetchFromGitHub
, rust-jemalloc-sys
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oxlint";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "web-infra-dev";
    repo = "oxc";
    rev = "oxlint_v${version}";
    hash = "sha256-hcn076GADmduX30eyFNKoFrOP5DDv2HgMY0EbvJOwJE=";
  };

  cargoHash = "sha256-wNdf3LA9QHkbTrchpv5CHz7PMftkIMyc2tGLQxC+4Kg=";

  buildInputs = [
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "--bin=oxlint" ];
  cargoTestFlags = cargoBuildFlags;

  meta = with lib; {
    description = "Suite of high-performance tools for JavaScript and TypeScript written in Rust";
    homepage = "https://github.com/web-infra-dev/oxc";
    changelog = "https://github.com/web-infra-dev/oxc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oxlint";
  };
}
