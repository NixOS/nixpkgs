{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "mubeng";
    rev = "refs/tags/v${version}";
    hash = "sha256-V+0XPuMM2Jg2LEpWzxRNLZ44YRoEnf/Fvbj51p9hwL4=";
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
