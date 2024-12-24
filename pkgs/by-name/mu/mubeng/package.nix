{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "mubeng";
    rev = "refs/tags/v${version}";
    hash = "sha256-DZwtHLSsV6JYEqb6fdLtJs8DdaMBBb0uSx6AL1cjjBs=";
  };

  vendorHash = "sha256-TZDQCvcwsCa08bBBb8Zs8W0OFDYb+ZWN85+VCelFgyc=";

  ldflags = [
    "-s"
    "-w"
    "-X=ktbs.dev/mubeng/common.Version=${version}"
  ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    changelog = "https://github.com/kitabisa/mubeng/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "mubeng";
  };
}
