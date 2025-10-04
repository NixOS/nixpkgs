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
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "dunglas";
    repo = "mercure";
    rev = "v${version}";
    hash = "sha256-DmeBnvJhGYtEGoJDey8+Bb7MuP+Y1GLtQHg6QLoAzv4=";
  };

  sourceRoot = "${src.name}/caddy";

  vendorHash = "sha256-ZisV7+Mo8TMN+AUGPKHzEluzEShxZCuXrnYgySi57TY=";

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

  meta = {
    description = "Open, easy, fast, reliable and battery-efficient solution for real-time communications";
    homepage = "https://github.com/dunglas/mercure";
    changelog = "https://github.com/dunglas/mercure/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    platforms = lib.platforms.unix;
    mainProgram = "mercure";
  };
}
