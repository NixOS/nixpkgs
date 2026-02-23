{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prose";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "jgdavey";
    repo = "prose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3NkG05ZKpUmlxO4cJbEvCZbrp7tg9rP0jMCAzYFVCI=";
  };

  cargoHash = "sha256-6LRQ94ZtnlSCM1pRMhPGDSDEacFEUL0UiQAfoZZ3MMM=";

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI utility to reformat text";
    homepage = "https://github.com/jgdavey/prose";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ MoritzBoehme ];
    mainProgram = "prose";
  };
})
