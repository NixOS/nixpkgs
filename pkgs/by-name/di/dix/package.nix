{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dix";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bloxx12";
    repo = "dix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cSmxpzj5bNcMgfxJQiYwcwKjCrsTHxY+loRi+pzpFd4=";
  };

  cargoHash = "sha256-iYjDN3t1rZaZEm6TCUl/mZkVzxqYNHRTZkPipheG9EY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/bloxx12/dix";
    description = "Blazingly fast tool to diff Nix related things";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      bloxx12
      NotAShelf
    ];
    mainProgram = "dix";
  };
})
