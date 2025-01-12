{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = "refs/tags/${version}";
    hash = "sha256-qXFSO2VIPaGnB+5Wp/u0FTcKnpcMLxW6uNykKL681lU=";
  };

  cargoHash = "sha256-i6/wa2/ogyLwLBdIXqTYdJX9+SFf+p7Zm2j2Q3mje6w=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      johnpyp
      getchoo
    ];
    mainProgram = "riff";
  };
}
