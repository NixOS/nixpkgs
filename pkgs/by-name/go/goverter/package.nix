{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "goverter";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "jmattheis";
    repo = "goverter";
    tag = "v${version}";
    hash = "sha256-7uzkSI6ZqkCu+rhC2KMHU2i0geedy6gOKiLZwsFDExM=";
  };

  vendorHash = "sha256-wStuQhxrzd+LyHQi+k6ez6JT1xzZcPjJa09WqX70bys=";

  subPackages = [ "cmd/goverter" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate type-safe Go converters by defining function signatures";
    homepage = "https://github.com/jmattheis/goverter";
    changelog = "https://goverter.jmattheis.de/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ krostar ];
    mainProgram = "goverter";
  };
}
