{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhit";
  version = "2.0.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "rhit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JPEtATa57/ODYTbandGQkDdE8yBAGu6uXXuGEMaVg58=";
  };

  cargoHash = "sha256-CfjZK9CqZC45rk0Gucl0K7El6QOOt2/DRv1gQK/QJx4=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dystroy.org/rhit/";
    description = "Nginx log explorer";
    changelog = "https://github.com/Canop/rhit/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "rhit";
  };
})
