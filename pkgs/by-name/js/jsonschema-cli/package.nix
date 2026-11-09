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
  version = "0.60.2";
  __structuredAttrs = true;

  src = fetchCrate {
    pname = "jsonschema-cli";
    inherit (finalAttrs) version;
    hash = "sha256-NtEZvHzqkYMDMrxlY/WSx+nxVUMXfb0diQQfH+q+hSs=";
  };

  cargoHash = "sha256-kvg6P58UbGfn8urFhzO5UBB9TlvqS2/HJoaxOoTKzhU=";

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
