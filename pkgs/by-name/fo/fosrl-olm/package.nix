{
  lib,
  buildGoModule,
  fetchFromGitHub,
# versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "olm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "olm";
    tag = finalAttrs.version;
    hash = "sha256-a0gkEo5EuJpHpZ5fKAPBXSTRvZaQo6KOJu4Abi1EztU=";
  };

  vendorHash = "sha256-Ms8tLFKIa8GqmyFI7o+sQEpsZghNPIpq8BRCoY89Org=";

  # todo versioning when upstream adds it
  # nativeInstallCheckInputs = [ versionCheckHook ];
  # versionCheckProgramArg = [ "-version" ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tunneling client for Newt sites";
    homepage = "https://github.com/fosrl/olm";
    changelog = "https://github.com/fosrl/olm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
    ];
    mainProgram = "olm";
  };
})
