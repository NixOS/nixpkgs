{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "mdschema";
  version = "0.15.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jackchuka";
    repo = "mdschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T7sBYkdxqp8VDRyhWZqP/giKJYjnsywWegSkE4cR02M=";
  };

  vendorHash = "sha256-lfmzPOu/OJ7wWnO2upkMmai9iI7HMEpAj7fSZU0jdUs=";

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
