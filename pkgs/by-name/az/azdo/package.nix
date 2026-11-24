{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "azdo";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "elpulgo";
    repo = "azdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TtlZ7JkFCGKpj6p+Pv/w4buE6YdKFFWfWrquhDRUjsE=";
  };

  vendorHash = "sha256-Z4ZNi2CI6+wJs7OlNcAJ7UxD7IEHIc7LdAHgBAgINEc=";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/azdo-tui $out/bin/azdo
  '';

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "A TUI for working with Azure DevOps/GitHub";
    mainProgram = "azdo";
    homepage = "https://github.com/elpulgo/azdo";
    changelog = "https://github.com/elpulgo/azdo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kangazero
    ];
  };
})
