{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  rustPlatform,
  curl,
  openssl,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fund";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "acfoltzer";
    repo = "cargo-fund";
    tag = version;
    hash = "sha256-8mnCwWwReNH9s/gbxIhe7XdJRIA6BSUKm5jzykU5qMU=";
  };

  cargoHash = "sha256-9NozPJzQIuF2KHaT6t4qBU0qKtBbM05mHxzmHlU3Dr4=";

  # The tests need a GitHub API token.
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    curl
  ];

  meta = with lib; {
    description = "Discover funding links for your project's dependencies";
    mainProgram = "cargo-fund";
    homepage = "https://github.com/acfoltzer/cargo-fund";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ johntitor ];
  };
}
