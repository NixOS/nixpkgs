{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mdschema";
  version = "0.15.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jackchuka";
    repo = "mdschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XI7KsxfPgVKSYjUOoVXLU6SIhYMVjlJyq05FgrLPL0k=";
  };

  vendorHash = "sha256-m2nwsdYab7w+aT7a4eXXKjnTRCaddm5z9aJRk2KTyN4=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jackchuka/mdschema/internal/version.Version=${finalAttrs.version}"
    "-X=github.com/jackchuka/mdschema/internal/version.Commit=${finalAttrs.src.rev}"
    "-X=github.com/jackchuka/mdschema/internal/version.Date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A declarative schema-based Markdown validator that helps maintain consistent documentation structure across projects";
    homepage = "https://github.com/jackchuka/mdschema";
    changelog = "https://github.com/jackchuka/mdschema/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mdschema";
  };
})
