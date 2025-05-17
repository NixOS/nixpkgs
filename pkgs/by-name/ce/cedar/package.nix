{
  lib,
  cedar,
  testers,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cedar";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${version}";
    hash = "sha256-rF6r7BUwjRYK9MM0owLs77i7duNj710+PHoX1LGDO24=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6SvXJc7ow0zhCPqrI15n05FUBZOmYDnqV4YSclkTZ9I=";

  passthru = {
    tests.version = testers.testVersion { package = cedar; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Implementation of the Cedar Policy Language";
    homepage = "https://github.com/cedar-policy/cedar";
    changelog = "https://github.com/cedar-policy/cedar/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "cedar";
  };
}
