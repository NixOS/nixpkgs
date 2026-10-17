{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "pspy";
  version = "1.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dominicbreuker";
    repo = "pspy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7R4Tp0Q7wjAuTDukiehtRZOcTABr0YTnvrod9Jdwjok=";
  };

  vendorHash = "sha256-mgAsy2ufMDNpeCXG/cZ10zdmzFoGfcpCzPWIABnvJWU=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Monitor linux processes without root permissions";
    homepage = "https://github.com/dominicbreuker/pspy";
    changelog = "https://github.com/dominicbreuker/pspy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pspy";
  };
})
