{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gomodifytags";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "fatih";
    repo = "gomodifytags";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XVjSRW7FzXbGmGT+xH4tNg9PVXvgmhQXTIrYYZ346/M=";
  };

  vendorHash = "sha256-0eWrkOcaow+W2Daaw2rzugfS+jqhN6RE2iCdpui9aQg=";

  ldflags = [
    "-s"
    "-w"
  ];

  # gomodifytags doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go tool to modify struct field tags";
    mainProgram = "gomodifytags";
    homepage = "https://github.com/fatih/gomodifytags";
    changelog = "https://github.com/fatih/gomodifytags/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.bsd3;
  };
})
