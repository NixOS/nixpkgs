{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "github-mcp-server";
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.20.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-sl/IEydxi64Z+ArqcApEELfi3lyxJY4MhR2X9g1fUbY=";
  };

  vendorHash = "sha256-90hWzVIjDzP7DBVSIYIwJtG5I89saQTQCU50n4HVylY=";
=======
    hash = "sha256-1xr0AUAfYrxR7koCn9S3VJAw8PaJvFLNyzsblqyGyC0=";
  };

  vendorHash = "sha256-j0THkLxOcNTyUoyl3WkbjR+8urM4fmsg7Mt74S4wjqU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/github/github-mcp-server/releases/tag/v${finalAttrs.version}";
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = lib.licenses.mit;
    mainProgram = "github-mcp-server";
    maintainers = with lib.maintainers; [ logger ];
  };
})
