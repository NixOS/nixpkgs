{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, testers
, mercure
}:

buildGoModule rec {
  pname = "mercure";
  version = "0.15.6";

  src = fetchFromGitHub {
    owner = "dunglas";
    repo = "mercure";
    rev = "v${version}";
    hash = "sha256-sGMjb7Ilm+RqR6bRGLAYB/nciE5oHeitDllr4H11uHU=";
  };

  sourceRoot = "source/caddy";

  vendorHash = "sha256-v0YKlkflo7eKXh38uqsnxZlLr3+fFl8EMeUsf8UMU48=";

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
