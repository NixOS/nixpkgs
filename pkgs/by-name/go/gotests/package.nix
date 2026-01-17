{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotests";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "cweill";
    repo = "gotests";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lx8gbVm4s4kmm252khoSukrlj5USQS+StGuJ+419QZw=";
  };

  vendorHash = "sha256-/dP8uA1yWBrtmFNHUvcicPhA2qr5R2v1uSwYi+ciypg=";

  ldflags = [
    "-s"
    "-w"
  ];

  # tests are broken in nix environment
  doCheck = false;

  # gotests doesn't support --version
  doInstallCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate Go tests from your source code";
    mainProgram = "gotests";
    homepage = "https://github.com/cweill/gotests";
    changelog = "https://github.com/cweill/gotests/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ vdemeester ];
    license = lib.licenses.asl20;
  };
})
