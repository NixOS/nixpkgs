{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "resterm";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "unkn0wn-root";
    repo = "resterm";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-vpFwiVLF3ekPgjxTEl4UlY/oGK03prHRtt15k5i+M6I=";
  };

  vendorHash = "sha256-E/Y4kW5xy7YamUP5bxFmDCAK6RqiqGN7DpEPG1MaCHc=";

  subPackages = [ "cmd/resterm" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01_00:00:00_UTC"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based REST client";
    homepage = "https://github.com/unkn0wn-root/resterm";
    mainProgram = "resterm";
    license = lib.licenses.asl20;
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    maintainers = with lib.maintainers; [ lonerOrz ];
  };
})
