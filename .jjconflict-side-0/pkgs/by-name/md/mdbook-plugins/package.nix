{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-plugins";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "RustForWeb";
    repo = "mdbook-plugins";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5JhiW2RnDcbMUkN/NJvGCA5zp3EfX8H/WxSNYuJcaQk=";
  };

  cargoHash = "sha256-PzgS70DOkQAynfR/7dykcXrIQ+OQpP0CUQAGvDe0kEU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    curl
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  cargoBuildFlags = [
    "--bin=mdbook-tabs"
    "--bin=mdbook-trunk"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugins for mdBook";
    homepage = "https://mdbook-plugins.rustforweb.org/";
    changelog = "https://github.com/RustForWeb/mdbook-plugins/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "mdbook-tabs";
  };
})
