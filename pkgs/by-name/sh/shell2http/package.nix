{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  shell2http,
}:

buildGoModule (finalAttrs: {
  pname = "shell2http";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "msoap";
    repo = "shell2http";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jurZHeZeocHAZdsQ6q/XNfyNq1tu3EfOZ752fXGHR2Q=";
  };

  vendorHash = "sha256-bksh6Kwya5kX3c6k7PtMyc560qsUKXJm4vgH3hqlPyQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    installManPage shell2http.1
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = shell2http;
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Executing shell commands via HTTP server";
    mainProgram = "shell2http";
    homepage = "https://github.com/msoap/shell2http";
    changelog = "https://github.com/msoap/shell2http/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
