{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  cacert,
}:
rustPlatform.buildRustPackage rec {
  pname = "svix-cli";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-AIBfGyb1Q1cHCsRWpYwEQH38UAvrjlkqMbt32aQitz4=";
  };

  sourceRoot = "${src.name}/svix-cli";

  cargoHash = "sha256-q5rnetqkcjyNt1rtVgiuA0v0zi414SilSJ6LxFgkw4Y=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  env.AWS_LC_SYS_USE_SYSTEM = true;

  nativeCheckInputs = [ cacert ];

  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  meta = {
    mainProgram = "svix";
    description = "CLI for interacting with the Svix API";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ techknowlogick ];
  };
}
