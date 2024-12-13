{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.27.19";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    rev = "refs/tags/v${version}";
    hash = "sha256-W+69Jt0mdwLIBHZ8zg3oK8d2DwwvYHtHj1oQUW3vt6M=";
  };

  vendorHash = "sha256-SYu2ITSZIVtDczBfWJ5pFw4l0mkb3b7YvMzIrEcpOa8=";

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
