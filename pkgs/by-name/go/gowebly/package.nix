{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go_1_24,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule.override { go = go_1_24; } rec {
  pname = "gowebly";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gowebly";
    repo = "gowebly";
    tag = "v${version}";
    hash = "sha256-t4TcUhHo3QLvgGfiKg/tbmmDZb3mI5AlTr1PB0ru1rU=";
  };

  vendorHash = "sha256-N5L1oCVRM6GQipew8N9CL85jWY8Or/TQi8Z0rOWbyzQ=";

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
