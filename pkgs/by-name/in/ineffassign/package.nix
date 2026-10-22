{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ineffassign";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gordonklaus";
    repo = "ineffassign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3bn13aQCz7Zn7DUmOTawFYI/xHUqabXrrVOYlOC5J/g=";
  };

  vendorHash = "sha256-h6r13xxPRTlSdTwi88ITra7SizU1z4pXWsmqlG2frU8=";

  passthru.updateScript = nix-update-script { };

  allowGoReference = true;

  meta = {
    description = "Detect ineffectual assignments in Go code";
    mainProgram = "ineffassign";
    homepage = "https://github.com/gordonklaus/ineffassign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kalbasit
      bot-wxt1221
    ];
  };
})
