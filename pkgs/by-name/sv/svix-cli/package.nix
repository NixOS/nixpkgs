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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-1lf9OyoLlEaeTTsWTnfNOBUyNf2p0LNrnus/LiuRzb8=";
  };

  sourceRoot = "${src.name}/svix-cli";

  cargoHash = "sha256-3TiYMEC9Gc1ehetJcP2TowCnVtyISu/28YDGqmzoVMc=";

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
