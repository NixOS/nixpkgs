{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "redka";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nalgeon";
    repo = "redka";
    rev = "v${version}";
    hash = "sha256-PlEZMOrAPQh9RxJBw3zhaUoAH44lor7SFSpmODxUM4U=";
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
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.bsd3;
  };
}
