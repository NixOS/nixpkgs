{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swpui";
  version = "0.9.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "swpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JnWm+UFditTpDTLvWycSmS1jAJs5KaOF+ymVCeGzgAw=";
  };

  cargoHash = "sha256-FkQs9FLJ8JxvmfHwWx8kvv7UcX3YX+wyXinGeX5sNVQ=";

  meta = {
    description = "TUI utility to search and replace with a focus on ergonomics, speed and case-awareness";
    homepage = "https://github.com/beeb/swpui";
    changelog = "https://github.com/beeb/swpui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "swp";
  };
})
