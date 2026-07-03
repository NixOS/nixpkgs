{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bttf";
  version = "0.1.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "bttf";
    tag = finalAttrs.version;
    hash = "sha256-KB9ix/4UTNoxXAT+EuCtcjjFKurwPYrYBcx4H2ctv/E=";
  };

  cargoHash = "sha256-afmzxV+rN2Cw1cQltsml4Z6NsP3E5FEf/VY9RRWE+uc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command line tool for datetime arithmetic, parsing, formatting and more. Replacment for biff";
    homepage = "https://github.com/BurntSushi/bttf";
    changelog = "https://github.com/BurntSushi/bttf/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [
      kpbaks
      paepcke
    ];
    mainProgram = "bttf";
  };
})
