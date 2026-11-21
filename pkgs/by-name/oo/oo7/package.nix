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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "linux-credentials";
    repo = "oo7";
    tag = finalAttrs.version;
    hash = "sha256-SwE1UdSARKi3o0rnUa9jVbDOr88Vw6jDgcqeqHjWpSU=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  cargoHash = "sha256-WTK3FbXHvF2+yD4gmsHGHNMgwkArjB2YxelYkuvEA0g=";

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
