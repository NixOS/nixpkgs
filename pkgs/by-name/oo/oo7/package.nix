{
  fetchFromGitHub,
  lib,
  nix-update-script,
  oo7,
  pkg-config,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oo7";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "linux-credentials";
    repo = "oo7";
    tag = finalAttrs.version;
    hash = "sha256-9ObDRx/+/meVvPsh6ycizKB9Nf5AqFLd9qucJ0Na5GQ=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  cargoHash = "sha256-CNbfgR+E0haWjuYyd8ChQNrBuEE5TzKAEW17aQRWgt8=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.testVersion = testers.testVersion { package = oo7; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "James Bond went on a new mission as a Secret Service provider";
    homepage = "https://github.com/linux-credentials/oo7";
    changelog = "https://github.com/linux-credentials/oo7/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      getchoo
      Scrumplex
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oo7-cli";
  };
})
