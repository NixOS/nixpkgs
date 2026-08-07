{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stakk";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "glennib";
    repo = "stakk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+q94xzOV9rA7B1pBBt9ZjESzcV8mhraiMGgDQekZM7Y=";
  };

  cargoHash = "sha256-/Wx1n5zt+rBGtM04bi2PTiO8zqCJvgKz5aoTo7f08NI=";

  useNextest = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "Bridge Jujutsu (jj) bookmarks to GitHub stacked pull requests";
    homepage = "https://github.com/glennib/stakk";
    changelog = "https://github.com/glennib/stakk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      voidlily
      Br1ght0ne
    ];
    mainProgram = "stakk";
  };
})
