{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bttf";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "bttf";
    tag = finalAttrs.version;
    hash = "sha256-x1lr4cgv0v2USRxO4boo27JZ2RVs5K/pwtvrOYab6UQ=";
  };

  cargoHash = "sha256-gcHXs4ac+CO+ifZ2Yc4hViHAnpRKbbuT4TKrFdzyK0A=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command line tool for datetime arithmetic, parsing, formatting and more. Replacement for biff";
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
