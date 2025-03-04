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
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${version}";
    hash = "sha256-o4oSZcQdOQsCbu92w0jY/EQKGtQis+8tUxaLIqVC1po=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1vEI0dtdb9CKhNvFeBL8KdxSfzF77X7zl1xxpvvRCQk=";

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
