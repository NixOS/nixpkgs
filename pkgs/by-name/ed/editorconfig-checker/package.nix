{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  editorconfig-checker,
}:

buildGoModule (finalAttrs: {
  pname = "editorconfig-checker";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kvRORmfquabvNoIchQdXEXKYKLpNjy8tgvkS6a0vmEk=";
  };

  vendorHash = "sha256-Olp21Sbey3zW/OCc59w0wqcnq8lwRigu/De7A82H6YU=";

  # Tests run on source and don't expect vendor dir.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  passthru.tests.version = testers.testVersion {
    package = editorconfig-checker;
  };

  meta = {
    changelog = "https://github.com/editorconfig-checker/editorconfig-checker/releases/tag/${finalAttrs.src.tag}";
    description = "Tool to verify that your files are in harmony with your .editorconfig";
    mainProgram = "editorconfig-checker";
    homepage = "https://editorconfig-checker.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      zowoq
    ];
  };
})
