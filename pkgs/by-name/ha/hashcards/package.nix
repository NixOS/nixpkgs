{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  sqlite,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hashcards";
  version = "0.5.0";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "eudoxia0";
    repo = "hashcards";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XX3j5ljOpyIxFJq3NPAM7ZPGoc33BH0bGOFMzJJ7XEg=";
  };

  cargoHash = "sha256-CK4k8etB4MZUkJWk/OabuBuIN+AkT/GulsYS1Qa7NVE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    sqlite
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  preCheck = ''
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plain text-based spaced repetition system";
    homepage = "https://github.com/eudoxia0/hashcards";
    changelog = "https://github.com/eudoxia0/hashcards/blob/${finalAttrs.src.rev}/CHANGELOG.xsd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "hashcards";
  };
})
