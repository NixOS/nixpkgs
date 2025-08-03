{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "mubeng";
    tag = "v${version}";
    hash = "sha256-Zd9Cl4sFf1neDHgydxp24k84JKTAkkLB9DKRfTnKHgc=";
  };

  vendorHash = "sha256-1YO4NOxHHoSF9waI7x7yRvO4HOrs3qqaQxo3tiCp4t4=";

  ldflags = [
    "-s"
    "-w"
    "-X=ktbs.dev/mubeng/common.Version=${version}"
  ];

  meta = {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    changelog = "https://github.com/kitabisa/mubeng/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mubeng";
  };
}
