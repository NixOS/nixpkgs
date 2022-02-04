{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "skate";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    sha256 = "sha256-rUOFx0ebZs3xmsSz9oFvjINaHp9gIe7E/5UoJJ47aZc=";
  };

  vendorSha256 = "sha256-2jyhDSPO/Xg3xBCA93SMSlm7D+ze0MGbNtRpL82IAsk=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "A personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
