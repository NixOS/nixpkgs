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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7mqmDyyDs+BzCLXF6AiDS/uCUXgLf0ImRkqgR/OZ9DY=";
  };

  vendorHash = "sha256-/0SKWWZpCWWHKZqz1ZC+LbkXf6iow8LUT0Yg101tGs8=";

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
