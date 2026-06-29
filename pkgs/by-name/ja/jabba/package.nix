{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "jabba";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "Jabba-Team";
    repo = "jabba";
    tag = finalAttrs.version;
    hash = "sha256-TE5yr0zy3r2NDIypX+HM8B3n6Lr2+7c46KFd+izweSE=";
  };

  vendorHash = "sha256-ki+oZsOSmL7ZLMMLQUtPEiScMkwpnDOf58vwfJxVD20=";

  __structuredAttrs = true;
  strictDeps = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java version manager";
    homepage = "https://github.com/Jabba-Team/jabba";
    mainProgram = "jabba";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
