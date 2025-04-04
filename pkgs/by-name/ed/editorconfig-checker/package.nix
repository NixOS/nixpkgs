{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  editorconfig-checker,
}:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "v${version}";
    hash = "sha256-LoOuP98vRj/kzyWKKsXNPfE+9IELrKBtdSZvP7GtMew=";
  };

  vendorHash = "sha256-3mcz7tstVfIb1ATuCwDdQ5IyCtjSGaDWNw2qCmY/ObE=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  passthru.tests.version = testers.testVersion {
    package = editorconfig-checker;
  };

  meta = with lib; {
    changelog = "https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/${src.rev}";
    description = "Tool to verify that your files are in harmony with your .editorconfig";
    mainProgram = "editorconfig-checker";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [
      uri-canva
      zowoq
    ];
  };
}
