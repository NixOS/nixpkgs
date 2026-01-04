{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  alejandra,
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    tag = version;
    hash = "sha256-Oi1n2ncF4/AWeY6X55o2FddIRICokbciqFYK64XorYk=";
  };

  cargoHash = "sha256-IX4xp8llB7USpS/SSQ9L8+17hQk5nkXFP8NgFKVLqKU=";

  passthru.tests = {
    version = testers.testVersion { package = alejandra; };
  };

  meta = {
    description = "Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [
      _0x4A6F
      kamadorueda
      sciencentistguy
    ];
    mainProgram = "alejandra";
  };
}
