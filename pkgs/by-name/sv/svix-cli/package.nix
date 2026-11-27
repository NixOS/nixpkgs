{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "svix-cli";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uMqutf42/clBgDKb67FnSlyexH3SAe7rE1MJAKkZWZg=";
  };

  sourceRoot = "${finalAttrs.src.name}/svix-cli";

  cargoHash = "sha256-hDRHsKMAs/5+giGJZcbgeHY2gnA8NoZZKFCcbHmz++4=";

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
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ techknowlogick ];
  };
})
