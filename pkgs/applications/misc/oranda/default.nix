{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, oniguruma
, openssl
, xz
, zstd
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-MT0uwLDrofCFyyYiUOogF2kNs6EPS1qxPz0gdK+Tkkg=";
  };

  cargoHash = "sha256-dAnZc1VvOubfn7mnpttaB6FotN3Xc+t9Qn0n5uzv1Qg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
    oniguruma
    openssl
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = with lib; {
    description = "Generate beautiful landing pages for your developer tools";
    homepage = "https://github.com/axodotdev/oranda";
    changelog = "https://github.com/axodotdev/oranda/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
