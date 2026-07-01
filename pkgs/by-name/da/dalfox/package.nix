{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dalfox";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0amVlnLwwb7YAUbTce9gRmjv3W1FMgc2/XZQKCettTY=";
  };

  cargoHash = "sha256-pxlUEGCrJjoakAVpXFq2q73wEWiODsHvdax12quDlec=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Many unit tests perform live HTTP requests / OOB interactsh lookups and
  # fail in the sandbox.
  doCheck = false;

  doInstallCheck = true;

  meta = {
    description = "Tool for analyzing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
})
