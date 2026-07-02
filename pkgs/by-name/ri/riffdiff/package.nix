{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "riffdiff";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = finalAttrs.version;
    hash = "sha256-2C1aD9sXh/+spNxbLbw13WAJ6ijdYqkWgPbKrw3zTm0=";
  };

  cargoHash = "sha256-Jg9c7tSjluhHSl2GoZkZlkBs+ojCGjjQ3dheROUC60g=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnpyp
      getchoo
    ];
    mainProgram = "riff";
  };
})
