{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swpui";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "swpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w9JQPSIMQUAUu6wkOH7wZH9ZV8eGSieXHlrppovicjY=";
  };

  cargoHash = "sha256-JWeUv98zcgVQl1qXqD9wmpu4Dk0Qan0F9ypvcFpRxRM=";

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
