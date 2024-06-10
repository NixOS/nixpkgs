{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "jikken";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${version}";
    hash = "sha256-bV9NjwTcX1euk8zRJMGkAULegQmiT8z4jxngOwOPr+M=";
  };

  cargoHash = "sha256-gJg/l7L19qk6DELqo4fYc2ZWTHqKeUFEF3YU3+uyFjQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.IOKit
      darwin.apple_sdk_11_0.frameworks.Security
      darwin.apple_sdk_11_0.frameworks.SystemConfiguration
    ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Powerful, source control friendly REST API testing toolkit";
    homepage = "https://jikken.io/";
    changelog = "https://github.com/jikkenio/jikken/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ vinnymeller ];
    mainProgram = "jk";
  };
}
