{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opnborg";
  version = "0.1.184";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WjQy9LGJE+mcpuS+6h2ndsUqyyoroIPOLk/xwgzva0U=";
  };

  vendorHash = "sha256-obKLMRGwgsZMGOX+1AIODmzBJBJTlLcUJ9MvGnCT9WI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/opnborg";

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
