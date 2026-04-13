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
  version = "0.46.0";

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-tpapiI6FYHEgmI0XY5KZNNsZxKxkEN4BIJaNQXsMIJI=";
  };

  cargoHash = "sha256-1Wih2VwK3hzdjuoAZI/1j0jPwWwL4l4y4rQRX0VV4Sc=";

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
