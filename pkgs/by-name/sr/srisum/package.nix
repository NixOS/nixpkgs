{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "srisum";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "zkat";
    repo = "srisum-rs";
    rev = "v${version}";
    hash = "sha256-Nw3uTGOcz1ivAm9X+PnOdNA937wuK3vtJQ0iJHlHVdw=";
  };

  cargoHash = "sha256-J++aj925krYvOTzcuVZSEk+eYupL0M7o407fd1dCjeA=";

  doInstallCheck = true;

  meta = {
    description = "Command-line utility to compute and check subresource integrity hashes";
    homepage = "https://github.com/zkat/srisum-rs";
    changelog = "https://github.com/zkat/srisum-rs/raw/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ pjjw ];
    platforms = lib.platforms.all;
    mainProgram = "srisum";
  };
}
