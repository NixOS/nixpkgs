{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  aws-lc,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsonschema-cli";
  version = "0.61.2";
  __structuredAttrs = true;

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-8TPV0CK68qJE0kuJlq2S9K/QISiN62IbV6TgvLXFt5g=";
  };

  cargoHash = "sha256-BC32sfqKrGO0du7k75gwO8AtN1UWTcpYlDKVAuPUe+I=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  env = {
    AWS_LC_SYS_USE_SYSTEM = true;
  };

  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast command-line tool for JSON Schema validation";
    homepage = "https://github.com/Stranger6667/jsonschema";
    changelog = "https://github.com/Stranger6667/jsonschema/releases/tag/rust-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "jsonschema-cli";
    platforms = with lib.platforms; unix ++ windows;
  };
})
