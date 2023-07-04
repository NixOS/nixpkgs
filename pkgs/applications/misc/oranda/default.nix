{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-bhMScPxf1svC6C8MvSHsVFrNzJYCkcR4mPJzK4OIoOU=";
  };

  cargoHash = "sha256-Zan5dTW/2k4rOl20lQwJWnzIiytKF2i+1oEW4o3k/vQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Generate beautiful landing pages for your developer tools";
    homepage = "https://github.com/axodotdev/oranda";
    changelog = "https://github.com/axodotdev/oranda/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
