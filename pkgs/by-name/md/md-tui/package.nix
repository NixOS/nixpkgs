{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "md-tui";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    tag = "v${version}";
    hash = "sha256-pOo+gifWomZh3hTfqaIRMPEPR5TPinzl8NgYcCit7t4=";
  };

  cargoHash = "sha256-07U69UdiAqdIv5JVfvbLNfQD/SfPfaiYZsMr6y/r8UY=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown renderer in the terminal";
    homepage = "https://github.com/henriklovhaug/md-tui";
    changelog = "https://github.com/henriklovhaug/md-tui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      anas
    ];
    platforms = lib.platforms.all;
    mainProgram = "mdt";
  };
}
