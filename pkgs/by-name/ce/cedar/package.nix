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
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "cedar-policy";
    repo = "cedar";
    tag = "v${version}";
    hash = "sha256-1EJvLQDQQTiNwPe0Ynt6VI3RD/3jGbt/0H7pzGcl1wA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-vkJjUmzuYwR/GI/7h0S2AOXJ8Im074a7QzXDs23rIak=";

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
