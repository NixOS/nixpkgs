{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  alejandra,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alejandra";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    tag = finalAttrs.version;
    hash = "sha256-7NLiwk8LB7U9qWrSyz+VqBbGLDuzskw7g52PSwk0kL8=";
  };

  cargoHash = "sha256-2zl5Qcunm50Gbt1cZPk9h293jMj8E3U9h+gVhmA4YPc=";

  passthru.tests = {
    version = testers.testVersion { package = alejandra; };
  };

  meta = {
    description = "Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      _0x4A6F
      kamadorueda
      sciencentistguy
    ];
    mainProgram = "alejandra";
  };
})
