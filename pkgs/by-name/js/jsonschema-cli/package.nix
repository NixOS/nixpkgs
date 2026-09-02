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
  version = "0.52.1";

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-/RObXfxdgY4PFilPGBVeLGhtEhueX8l035pn6g1QNsk=";
  };

  cargoHash = "sha256-jqbS9DqWe6C5C8BBbR0dGgGCpY3t3xHBA+wy+UqabK4=";

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
