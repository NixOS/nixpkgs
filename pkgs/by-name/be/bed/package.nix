{
  lib,
  buildGoModule,
  fetchFromGitHub,
  which,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bed";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "bed";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NXTQMyCI4PKaQPxZqklH03BEDMUrTCNtFUj2FNwIsNM=";
  };
  vendorHash = "sha256-tp83T6V4HM7SgpZASMWnIoqgw/s/DhdJMsCu2C6OuTo=";

  nativeBuildInputs = [ which ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "-version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Binary editor written in Go";
    homepage = "https://github.com/itchyny/bed";
    changelog = "https://github.com/itchyny/bed/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "bed";
  };
})
