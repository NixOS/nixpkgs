{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-1pkAIz6Zh0ArIDmRSLHTnIgySWdxrDx0amTkdZhY6vY=";
  };

  cargoHash = "sha256-TKpPAzqwWBH2dlBNvU2kuqqOVu5WhSnSR3wW5FsW7yk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
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
