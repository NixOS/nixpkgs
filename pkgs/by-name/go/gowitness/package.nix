{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gowitness";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    tag = version;
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

  meta = with lib; {
    description = "Web screenshot utility";
    homepage = "https://github.com/sensepost/gowitness";
    changelog = "https://github.com/sensepost/gowitness/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gowitness";
  };
}
