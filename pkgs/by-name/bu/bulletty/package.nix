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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "CrociDB";
    repo = "bulletty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HX5J00Y7nkBwLIOEoc9jRtv9xObeWrWpHhYBQUOUVKA=";
  };

  patches = [
    # Add patch that disables rustfmt to prevent compile time crashes
    ./remove-rustfmt-exec.patch
  ];

  cargoHash = "sha256-WIEbZIWdIGWiwi6918MVFu++aZ2oWJTF4AUSTpKRZvQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

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
