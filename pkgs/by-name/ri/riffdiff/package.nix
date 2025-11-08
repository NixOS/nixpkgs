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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = version;
    hash = "sha256-WpVj/sgvvdNweZ+exxoSc4rtDmuRvaIdkwKk+eu46Ok=";
  };

  cargoHash = "sha256-YJnqeuj4XvOnGJ9RcNBtfy1duYUu/u6ed47bAndLm30=";

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
