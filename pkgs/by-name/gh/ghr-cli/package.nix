{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  gitMinimal,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghr-cli";
  version = "0.9.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chenyukang";
    repo = "ghr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LmQaBPPX+VRWFHDMvzyhtWcoiEZJocNeyu6EKBX4IjI=";
  };

  cargoHash = "sha256-UCu/z6TzNYV0scWnl5XnN+nj9V9cg9hpUNqFZXlMXaM=";

  passthru.updateScript = nix-update-script { };

  nativeCheckInputs = [
    gitMinimal
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Fast terminal workspace for staying on top of GitHub";
    homepage = "https://catcoding.me/ghr/";
    changelog = "https://github.com/chenyukang/ghr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "ghr";
  };
})
