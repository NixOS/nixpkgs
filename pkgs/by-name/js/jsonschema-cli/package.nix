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
  version = "0.60.1";
  __structuredAttrs = true;

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-vEoShzy7njIE96JPPtn3P2gMqUOwcwbAYGbgK/clEKM=";
  };

  cargoHash = "sha256-gm91KHXJFAjlBTgFfbxMymBvu+SQpVa7azS3jaGHmaE=";

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
