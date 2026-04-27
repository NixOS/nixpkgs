{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ghqr";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ghqr";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-QNonvy0T5IkROyzqzBJmpStjtl03v9A7xhVjDRSbUL8=";
  };

  vendorHash = "sha256-CCg0FXwnhuNBDFlaXybIIeuo5VhHIMlP6CozDehzfNE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/microsoft/ghqr/cmd/ghqr/commands.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Evaluate your enterprise and organizations with GitHub best practices";
    homepage = "https://github.com/microsoft/ghqr";
    changelog = "https://github.com/microsoft/ghqr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "ghqr";
  };
})
