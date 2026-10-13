{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gowitness";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    tag = finalAttrs.version;
    hash = "sha256-XFzU2zqKyHO89LUIcbL1wRYNkFv/ps1UrobDqmhrVRY=";
  };

  vendorHash = "sha256-B6T60o4kwezYH9OXJqbv8VrNpcfVghC+QiA+dmzuDVY=";

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gowitness";
  };
})
