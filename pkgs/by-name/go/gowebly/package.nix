{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gowebly";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "gowebly";
    repo = "gowebly";
    tag = "v${version}";
    hash = "sha256-T0JiyTa/ouM/ldd1Hr2dAePA8cqHfHMzq1njr8sEH0Q=";
  };

  vendorHash = "sha256-2/jibPP6XE6e8aHE9vwJ4UiQ8fPsnLifCOaz3fZuakU=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "doctor";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A CLI tool that makes it easy to create web applications with Go on the backend, using htmx, hyperscript or Alpine.js, and the most popular CSS frameworks on the frontend";
    homepage = "https://gowebly.org";
    changelog = "https://github.com/gowebly/gowebly/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "gowebly";
    maintainers = with lib.maintainers; [ cterence ];
  };
}
