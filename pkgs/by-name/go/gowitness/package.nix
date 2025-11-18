{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gowitness";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "gowitness";
    tag = version;
    hash = "sha256-i7yaen7Ht34D6Ryt5C/oFnBVx9M2uQEJGA1t1OCpcyo=";
  };

  vendorHash = "sha256-IvOmBCJ07ASKpxgk6+FLNg4wJi6E0Lh38f+DAnR0gDg=";

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
