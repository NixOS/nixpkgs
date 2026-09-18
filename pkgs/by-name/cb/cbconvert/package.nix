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

buildGoModule (finalAttrs: {
  pname = "cbconvert";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "gen2brain";
    repo = "cbconvert";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fLAVX3AlHUp2jmb8AiFeqB4IhVcWxYk0tkjvwWiKwPc=";
  };

  env.GOWORK = "off";

  vendorHash = "sha256-lR1ZbEDNjJ9+bl8ijdI5/ifC5uIB1rdbnXQh5D2T7NM=";
  modRoot = "cmd/cbconvert";

  # The extlib tag forces the github.com/gen2brain/go-unarr module to use external libraries instead of bundled ones.
  tags = [ "extlib" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
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
    changelog = "https://github.com/gen2brain/cbconvert/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "cbconvert";
  };
})
