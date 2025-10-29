{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  perl,
  pkg-config,
  curl,
  libiconv,
  openssl,
  gitMinimal,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.26.5";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "sha256-P6i2RvosI36rrg52kUcdrb5y4Fg0ms/mH5hcOWNgSik=";
  };

  cargoHash = "sha256-ZlcKnSVpMxQqstbr/VkR/iT1B0wR5qnh5VLpNpYsTRw=";

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name "Nixpkgs Test"
    git config --global user.email "nobody@example.com"
  '';

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    curl
  ];

  nativeCheckInputs = [ gitMinimal ];

  meta = with lib; {
    description = "Cryptographically verifiable code review system for the cargo (Rust) package manager";
    mainProgram = "cargo-crev";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [
      asl20
      mit
      mpl20
    ];
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
  };
}
