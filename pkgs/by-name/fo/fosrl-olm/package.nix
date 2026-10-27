{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-/FhfpVwBEwx7HoaTzdgqSdN0rd2rqkx/FwC+GWofSlo=";
  };

  vendorHash = "sha256-L0317eHaf0mt79kcquIh1IN5vVsGn3XyVQC6rdrayPA=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.olmVersion=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  __structuredAttrs = true;

  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      water-sucks
    ];
    mainProgram = "olm";
  };
})
