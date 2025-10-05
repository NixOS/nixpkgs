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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = version;
    hash = "sha256-IpEgWbmWFW4X09EeAfWadncH4ptzSom2+7kvh8h3hcM=";
  };

  cargoHash = "sha256-I0hBh9FFoy+RhEUAHfgQa+UiSgOS0mYJy+2W/0/9kG4=";

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
