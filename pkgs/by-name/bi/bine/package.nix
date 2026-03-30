{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bine";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "hymkor";
    repo = "bine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9etWDQN8hrJZxJs+KUpeJmL5JuBm1S4o+PzBj9riCU=";
  };

  vendorHash = "sha256-p4/O2242QRWJbGeCwL+xBEkF9Dy4Q9K1P0X6ubo0JbM=";

  ldflags = [ "-s" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/hymkor/bine/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Fast terminal hex editor for large files and pipelines";
    homepage = "https://github.com/hymkor/bine";
    license = lib.licenses.mit;
    mainProgram = "bine";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
