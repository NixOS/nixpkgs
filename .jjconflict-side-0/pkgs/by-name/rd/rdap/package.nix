{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "rdap";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "openrdap";
    repo = "rdap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dlRIKf/NikCxiKub6qFmC+e3J1XllaVodzVZvUyvycE=";
  };

  vendorHash = "sha256-F9kwlUwrV6cUT9C/xZx5TyDPoqTt8mt/uh+QYaSCiUw=";

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
