{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bulletty";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Keo7Xl8dU5ZnUxXilf93qVv0tjx5O2JfWU1obzrprxo=";
  };

  patches = [
    # Add patch that disables rustfmt to prevent compile time crashes
    ./remove-rustfmt-exec.patch
  ];

  cargoHash = "sha256-bwQcmA0/wQmwEobhDkDCi5s3MgxxCi0I4m2yuQ2/XZo=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal UI RSS/ATOM feed reader";
    homepage = "https://bulletty.croci.dev";
    changelog = "https://github.com/CrociDB/bulletty/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.FKouhai ];
    mainProgram = "bulletty";
  };
})
