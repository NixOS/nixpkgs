{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "goverter";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PPGH4AqlBNBL0xsUNLmMqBEjlcQVpe/9HakLGTJPYC4=";
  };

  vendorHash = "sha256-SVrjjnYe6Zge114Zlz1iwbeaih2VzV2XTiENuNcC1g8=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
})
