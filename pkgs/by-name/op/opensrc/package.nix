{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opensrc";
  version = "0.7.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "opensrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t7QVes9MN8JsJMGtKsTUnErZDRbzGXsIOBpKJxumvFg=";
  };
  sourceRoot = "${finalAttrs.src.name}/packages/opensrc/cli";

  cargoHash = "sha256-ol4MoeOqKtmVhdljp/264/vNoRsPPJHY6rsmuaohT/E=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fetch source code for npm packages to give AI coding agents deeper context";
    homepage = "https://github.com/vercel-labs/opensrc";
    changelog = "https://github.com/vercel-labs/opensrc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "opensrc";
    platforms = lib.platforms.all;
  };
})
