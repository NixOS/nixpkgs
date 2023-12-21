{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, mercure
}:

buildGoModule rec {
  pname = "mercure";
  version = "0.15.7";

  src = fetchFromGitHub {
    owner = "dunglas";
    repo = "mercure";
    rev = "v${version}";
    hash = "sha256-3ar8LoIBwxBovyL9TUCHV13A9IvGp77wt7tNFvE3eEs=";
  };

  sourceRoot = "source/caddy";

  vendorHash = "sha256-pN0FnRy1d+iDpFImCQMWRzs6uG8qgAYY1AREMrCsNfQ=";

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
    description = "An open, easy, fast, reliable and battery-efficient solution for real-time communications";
    homepage = "https://github.com/dunglas/mercure";
    changelog = "https://github.com/dunglas/mercure/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ gaelreyrol ];
    platforms = platforms.unix;
    mainProgram = "mercure";
  };
}
