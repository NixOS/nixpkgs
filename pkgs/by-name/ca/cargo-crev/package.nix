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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-crev";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ezMpxYrJJ2zqEwCaDu2DFMwd6d/nfPVO6z2Lm4elIYE=";
  };

  cargoHash = "sha256-CYvvwgDZ+yAr7kLGEVZLVx7+sZUc5vu85AT5xLJBSbQ=";

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

  meta = {
    description = "Cryptographically verifiable code review system for the cargo (Rust) package manager";
    mainProgram = "cargo-crev";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with lib.licenses; [
      asl20
      mit
      mpl20
    ];
    maintainers = with lib.maintainers; [
      b4dm4n
      matthiasbeyer
    ];
  };
})
