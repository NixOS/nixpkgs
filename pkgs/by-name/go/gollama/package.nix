{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    rev = "refs/tags/v${version}";
    hash = "sha256-nQrd0gpl6fjJ5wzDvDGpI01h7jeGEyB6uuObgoz7Uo8=";
  };

  vendorHash = "sha256-vIqDYtdz799qm3vp8w293OLx1IoLNr5YjyNqYcvOkI0=";

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
