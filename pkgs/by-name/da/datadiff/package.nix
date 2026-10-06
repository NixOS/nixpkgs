{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datadiff";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dimanovikov";
    repo = "datadiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5m+M1mDQ5/1TLZk3mB+zY7Tn0A7iHx775k7hyBy1PGQ=";
  };

  cargoHash = "sha256-LOLFOX3+9HMn36H/HzeLg/TYlaWqae1drOQHgzYghMs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic diff for JSON, YAML, CSV, TOML and XML that plugs into git diff";
    homepage = "https://github.com/dimanovikov/datadiff";
    changelog = "https://github.com/dimanovikov/datadiff/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dimanovikov ];
    mainProgram = "datadiff";
  };
})
