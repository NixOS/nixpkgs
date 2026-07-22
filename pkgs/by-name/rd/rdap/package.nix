{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "rdap";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FiaUyhiwKXZ3xnFPmdxb8bpbm5eRRFNDL3duOGDnc/A=";
  };

  vendorHash = "sha256-8b1EAnR8PkEAw9yLBqPKFeANJit0OCJG+fssAGR/iTk=";

  doCheck = false;

  ldflags = [
    "-s"
    "-X=github.com/openrdap/rdap.version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-h" ];

  meta = {
    description = "Command line client for the Registration Data Access Protocol (RDAP)";
    homepage = "https://www.openrdap.org/";
    changelog = "https://github.com/openrdap/rdap/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebastianblunt ];
    mainProgram = "rdap";
  };
})
