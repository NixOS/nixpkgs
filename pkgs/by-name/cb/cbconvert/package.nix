{
  buildGoModule,
  bzip2,
  callPackage,
  fetchFromGitHub,
  lib,
  libunarr,
  mupdf-headless,
  nix-update-script,
  versionCheckHook,
  zlib,
}:

buildGoModule rec {
  pname = "cbconvert";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "gen2brain";
    repo = "cbconvert";
    rev = "v${version}";
    hash = "sha256-C2Eox6fpKS0fPB7KFgBn62HKbWYacSVMJK0CkT6+FBU=";
  };

  vendorHash = "sha256-uV8aIUKy9HQdZvR3k8CTTrHsh9TyBw21gFTdjR1XJlg=";
  modRoot = "cmd/cbconvert";

  # The extlib tag forces the github.com/gen2brain/go-unarr module to use external libraries instead of bundled ones.
  tags = [ "extlib" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${version}"
  ];

  buildInputs = [
    bzip2
    libunarr
    mupdf-headless
    zlib
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru = {
    gui = callPackage ./gui.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Comic Book converter";
    homepage = "https://github.com/gen2brain/cbconvert";
    changelog = "https://github.com/gen2brain/cbconvert/releases/tag/v${version}";
    license = with lib.licenses; [ gpl3Only ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "cbconvert";
  };
}
