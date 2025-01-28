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
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "v${version}";
    hash = "sha256-EWLk4VHeA32VErULJwPHKLRMb5qaET7fnpBxLx5f7YE=";
  };

  vendorHash = "sha256-GNUkU/cmu8j6naFAHIEZ56opJnj8p2Sb8M7TduTbJcU=";

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
