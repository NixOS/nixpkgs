{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    sha256 = "sha256-bs73WISj6iL5KGzJLCD06MeL9C/lYrv42x+0JMKyQOs=";
  };

  vendorSha256 = "sha256-VQvumXQx5Q0gt51NI65kjSnzGRyScpli36vfCygtAjE=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
