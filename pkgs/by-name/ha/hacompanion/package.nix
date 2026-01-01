{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "hacompanion";
<<<<<<< HEAD
  version = "1.0.24";
=======
  version = "1.0.23";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tobias-kuendig";
    repo = "hacompanion";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Lzy25tay8PJvEtZURLec5366nWJElI8D7oDckZmIEoU=";
=======
    hash = "sha256-C86XRgNwR0VD0Dph4D7ysB9ul6fBw1MTK++ODsJrE8k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
