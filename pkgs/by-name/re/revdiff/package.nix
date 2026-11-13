{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "revdiff";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "revdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lSqSWsA5nI4u6n3bmtjaMjPlwL6gShbLESbxlAyrh5k=";
  };

  vendorHash = null;

  subPackages = [ "app" ];

  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-s"
    "-w"
    "-X main.revision=${finalAttrs.version}"
  ];

  preCheck = ''
    # TestGitTopLevel expects the source directory to be a Git repository.
    git init --initial-branch=main
  '';

  postInstall = ''
    mv $out/bin/app $out/bin/revdiff
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal interface for reviewing diffs, files, and documents with inline annotations";
    homepage = "https://github.com/umputun/revdiff";
    changelog = "https://github.com/umputun/revdiff/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sheeeng ];
    mainProgram = "revdiff";
  };
})
