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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "linux-credentials";
    repo = "oo7";
    tag = finalAttrs.version;
    hash = "sha256-mwmMCr3qmkMnm0L0W5XDJawM2GtM4SIXqtJSfaW/pgY=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  cargoHash = "sha256-K0S3J6i3tf/yeu8dkrIvoKlImyFq+JipDrLz5bFy8q4=";

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
