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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HQYZXwxysGpbNDAzgAruzBtSlPxfwrLuzirkZSV2Xhs=";
  };

  vendorHash = "sha256-zlARI7bKf+4bdgCha9AlDZyTRbrOHtmvHeExJWhB85I=";

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
      uri-canva
      zowoq
    ];
  };
})
