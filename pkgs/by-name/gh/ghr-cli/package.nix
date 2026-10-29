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
  version = "0.9.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chenyukang";
    repo = "ghr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JxGJ0nOR/66Reg/1dd3jy7O4H/mK7CdoiFtR4+3Tjss=";
  };

  cargoHash = "sha256-si8sQXC/F6PYYgGh7PT3jxKmLBzmp3QzlH1szYerA4k=";

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
