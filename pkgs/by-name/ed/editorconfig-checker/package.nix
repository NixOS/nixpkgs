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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "v${version}";
    hash = "sha256-qQXIsG7g75Q3Ue7tYsGviNsV+9ljg8Y6adRozdX085A=";
  };

  vendorHash = "sha256-uj+/cAF22dvg0QBjxjqF0WIRlfvQtoW2/kEh/pY8TfE=";

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
