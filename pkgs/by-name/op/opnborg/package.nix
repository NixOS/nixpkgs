{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "opnborg";
  version = "0.1.68";

  src = fetchFromGitHub {
    owner = "paepckehh";
    repo = "opnborg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fES3YlJu8Zy1CLNEkzWW0KAhy3dZj1JXAT8y9tRjyEA=";
  };

  vendorHash = "sha256-u1LZvLAKYd1TQlZkYxgztOm1g94N4orMe6Y1Ab1to5Y=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/opnborg";
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/paepckehh/opnborg/releases/tag/v${finalAttrs.version}";
    homepage = "https://paepcke.de/opnborg";
    description = "Sefhosted OPNSense Appliance Backup & Configuration Management Portal";
    license = lib.licenses.bsd3;
    mainProgram = "opnborg";
    maintainers = with lib.maintainers; [ paepcke ];
  };
})
