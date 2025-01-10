{
  apple-sdk_15,
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "jikken";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${version}";
    hash = "sha256-WJxrCCDe39RYwHb+zbr7ugFsFsP5Uc/arw3s6USQoN4=";
  };

  cargoHash = "sha256-vyByA05rcGd8/O9PKcIlUF8tq2UkomryW1nFsfqQNlk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

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
