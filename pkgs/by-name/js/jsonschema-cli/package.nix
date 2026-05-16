{
  lib,
  fetchCrate,
  rustPlatform,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsonschema-cli";
  version = "0.46.4";

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-Yze2iL+4SAR3WUgypGM94OKKFlD4PTLrvsP+nJz9Kho=";
  };

  cargoHash = "sha256-28OtvYDv7OpIio7WghkuVA8t+d0b91bQ9U/llJEFzmw=";

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
  };
})
