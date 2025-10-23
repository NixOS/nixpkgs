{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "flex-ncat";
  version = "0.6-20250801.0";

  src = fetchFromGitHub {
    owner = "kc2g-flex-tools";
    repo = "nCAT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+A7PlckZFGwibMU5QelMzANP1WS5WPApOnQV0P+SGw=";
  };

  vendorHash = "sha256-daMeYk64xzDPIyZl7SdXaQbu2Dvdw/yVV87/8Agvxk0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kc2g-flex-tools/nCAT";
    description = "FlexRadio remote control (CAT) via hamlib/rigctl protocol";
    changelog = "https://github.com/kc2g-flex-tools/nCAT/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mvs ];
    mainProgram = "nCAT";
  };
})
