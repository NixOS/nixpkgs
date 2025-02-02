{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  mercure,
}:

buildGoModule rec {
  pname = "mercure";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "dunglas";
    repo = "mercure";
    rev = "v${version}";
    hash = "sha256-BJVCVvz8AdkQwLD37oQc7YPaZ7l74o9Dik9u/ZBSRro=";
  };

  sourceRoot = "${src.name}/caddy";

  vendorHash = "sha256-QqG8rxGQW+Lmd2L+wKiKUV+GXcxoO04yhJhDvMqwTVc=";

  subPackages = [ "mercure" ];
  excludedPackages = [ "../cmd/mercure" ];

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/caddyserver/caddy/v2.CustomVersion=Mercure.rocks v${version} Caddy'"
  ];

  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      version = "v${version}";
      package = mercure;
      command = "mercure version";
    };
  };

  meta = with lib; {
    description = "Open, easy, fast, reliable and battery-efficient solution for real-time communications";
    homepage = "https://github.com/dunglas/mercure";
    changelog = "https://github.com/dunglas/mercure/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = platforms.unix;
    mainProgram = "mercure";
  };
}
