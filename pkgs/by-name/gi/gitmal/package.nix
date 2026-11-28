{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gitmal";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "gitmal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RDXtB/fgyqL3b5e2BVK5si5pIcw/un3KJy1/cU0GMXo=";
  };

  vendorHash = "sha256-12kkN1rh9OWG8YIr9KyHtm1TFJQPUtSpD6ub8zokAhQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Static site generator for Git repositories";
    longDescription = ''
      Gitmal generates static HTML pages for Git repositories with features including:
      - File browsing with syntax highlighting
      - Commit history visualization
      - Markdown rendering
      - Customizable themes
    '';
    homepage = "https://github.com/antonmedv/gitmal";
    changelog = "https://github.com/antonmedv/gitmal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "gitmal";
  };
})
