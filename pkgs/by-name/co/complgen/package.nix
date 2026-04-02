{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "complgen";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "adaszko";
    repo = "complgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z4jR2evvC0p306UeULroCLwaa7sjYUh7ENWp17FolAw=";
  };

  cargoHash = "sha256-VhfIUP9NjsgoJ0qNUFwWdaZpWAWzSlmVgPI8kNeFVgM=";

  meta = {
    changelog = "https://github.com/adaszko/complgen/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Generate {bash,fish,zsh} completions from a single EBNF-like grammar";
    homepage = "https://github.com/adaszko/complgen";
    license = lib.licenses.asl20;
    mainProgram = "complgen";
    maintainers = with lib.maintainers; [ hythera ];
  };
})
