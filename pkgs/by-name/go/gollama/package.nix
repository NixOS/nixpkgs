{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.27.17";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    rev = "refs/tags/v${version}";
    hash = "sha256-/KemOJwVHdb2BJnV53EVvbuE+0s3WOj4kzcox8hRZ6w=";
  };

  vendorHash = "sha256-MbadjPW9Oq3lRVa+Qcq4GXaZnBL0n6qLh5I2hJ0XhaY=";

  doCheck = false;

  ldFlags = [
    "-s"
    "-w"
  ];

  nativeInputChecks = [
    versionCheckHook
  ];

  versionCheckProgramArg = [ "-v" ];

  meta = {
    description = "Go manage your Ollama models";
    homepage = "https://github.com/sammcj/gollama";
    changelog = "https://github.com/sammcj/gollama/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gollama";
  };
}
