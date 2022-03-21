{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "charm";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "charm";
    rev = "v${version}";
    sha256 = "sha256-7WdSIpmpN8Zz2k5PveYZoCueQo5sLxLLZvZdzxRlkaE=";
  };

  vendorSha256 = "sha256-5cqZxh2uvmJV7DtAGzQwt//heF3kF9mjyB0KAs8nWZY=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    description = "Manage your charm account on the CLI";
    homepage = "https://github.com/charmbracelet/charm";
    license = licenses.mit;
    maintainers = with maintainers; [ penguwin ];
  };
}
