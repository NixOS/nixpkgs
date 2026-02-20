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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "oo7";
    rev = finalAttrs.version;
    hash = "sha256-FIHXjbxAqEH3ekTNL0/TBFZoeDYZ84W2+UeJDxcauk8=";
  };

  # TODO: this won't cover tests from the client crate
  # Additionally cargo-credential will also not be built here
  buildAndTestSubdir = "cli";

  cargoHash = "sha256-4ibhHCRBsEcwG5+6Gf/uuswA/k9zJLj+RcMdmBcmvD4=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    tests.testVersion = testers.testVersion { package = oo7; };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "James Bond went on a new mission as a Secret Service provider";
    homepage = "https://github.com/bilelmoussaoui/oo7";
    changelog = "https://github.com/bilelmoussaoui/oo7/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      getchoo
      Scrumplex
    ];
    platforms = lib.platforms.linux;
    mainProgram = "oo7-cli";
  };
})
