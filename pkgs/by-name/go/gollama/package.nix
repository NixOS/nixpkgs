{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gollama";
  version = "1.28.4";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    rev = "refs/tags/v${version}";
    hash = "sha256-n3GbEPh69mrr5qZ2TVzKv06lkR+zuhH9TtjmusXDHQg=";
  };

  vendorHash = "sha256-Y5yg54em+vqoWXxS3JVQVPEM+fLXgoblmY+48WpxSCQ=";

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
