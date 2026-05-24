{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hacompanion";
  version = "1.0.30";

  src = fetchFromGitHub {
    owner = "tobias-kuendig";
    repo = "hacompanion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TC1ZnYT5WGbKP2Y2pOKaLj8Hmr3lU+LShkNV2DpcyDk=";
  };

  vendorHash = "sha256-SohjueM0DwSuh7XVClYiWA/5d0V6x2vmp5aPxgmIJYY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/tobias-kuendig/hacompanion/releases/tag/v${finalAttrs.version}";
    description = "Daemon that sends local hardware information to Home Assistant";
    homepage = "https://github.com/tobias-kuendig/hacompanion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ramblurr ];
    mainProgram = "hacompanion";
  };
})
