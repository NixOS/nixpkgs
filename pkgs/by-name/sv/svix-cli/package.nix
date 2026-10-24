{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "svix-cli";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "svix";
    repo = "svix-webhooks";
    rev = "v${version}";
    hash = "sha256-uMqutf42/clBgDKb67FnSlyexH3SAe7rE1MJAKkZWZg=";
  };

  sourceRoot = "${src.name}/svix-cli";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    hash = "sha256-hDRHsKMAs/5+giGJZcbgeHY2gnA8NoZZKFCcbHmz++4=";
  };

  nativeCheckInputs = [ cacert ];

  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  meta = {
    mainProgram = "svix";
    description = "A CLI for interacting with the Svix API";
    homepage = "https://github.com/svix/svix-webhooks";
    changelog = "https://github.com/svix/svix-webhooks/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ techknowlogick ];
  };
}
