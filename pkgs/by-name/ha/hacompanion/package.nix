{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "hacompanion";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "tobias-kuendig";
    repo = "hacompanion";
    rev = "v${version}";
    hash = "sha256-C86XRgNwR0VD0Dph4D7ysB9ul6fBw1MTK++ODsJrE8k=";
  };

  vendorHash = "sha256-y2eSuMCDZTGdCs70zYdA8NKbuPPN5xmnRfMNK+AE/q8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/tobias-kuendig/hacompanion/releases/tag/v${version}";
    description = "Daemon that sends local hardware information to Home Assistant";
    homepage = "https://github.com/tobias-kuendig/hacompanion";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ramblurr ];
    mainProgram = "hacompanion";
  };
}
