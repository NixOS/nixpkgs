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
  version = "3.3.7";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = "refs/tags/${version}";
    hash = "sha256-PlE94OikRabxSr+23903nveXXa0DqqQmGgUJJfSZg1M=";
  };

  cargoHash = "sha256-ZDlhU6izva0lPi66Gv0fjpLcGiBBo/Ym6FizBhqmcuQ=";

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
