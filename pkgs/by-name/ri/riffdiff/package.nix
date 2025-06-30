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
  version = "3.3.10";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    tag = version;
    hash = "sha256-5HxQF8PVDonWpmxHEFT4zWZTWzzn50UzBU1z0ahuaGM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8O4ZLKaQajrvNp7tH8iuVRPriuIIdesBmuv5MXyTafA=";

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
