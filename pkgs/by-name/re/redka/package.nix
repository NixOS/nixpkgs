{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "redka";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "nalgeon";
    repo = "redka";
    rev = "v${version}";
    hash = "sha256-KpfXnhwz3uUdG89XdNqm1WyKwYhA5ImDg4DzzefKMz8=";
  };

  vendorHash = "sha256-aX0X6TWVEouo884LunCt+UzLyvDHgmvuxdV0wh0r7Ro=";

  subPackages = [ "cmd/redka" "cmd/cli" ];

  ldflags = [ "-X main.version=v${version}" ];

  postInstall = ''
    mv $out/bin/{cli,redka-cli}
  '';

  meta = {
    description = "Redis re-implemented with SQLite";
    homepage = "https://github.com/nalgeon/redka";
    changelog = "https://github.com/nalgeon/redka/releases/tag/${src.rev}";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.bsd3;
  };
}
