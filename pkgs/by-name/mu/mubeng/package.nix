{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "mubeng";
    tag = "v${version}";
    hash = "sha256-LApviKG6sgIYtosU0xW4lkBH0iB7MGB4bfG9fPI16iQ=";
  };

  vendorHash = "sha256-Uvxkvj5hodVQ0j05HZdSKammGWy9DxEIBT0VnCW8QuI=";

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
