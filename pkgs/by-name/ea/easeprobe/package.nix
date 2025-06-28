{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "easeprobe";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "megaease";
    repo = "easeprobe";
    rev = "v${version}";
    sha256 = "sha256-LrfUQxxoC20pJXdBWa8wMuxbTbD3DRnsOlIDdBarNMY=";
  };

  vendorHash = "sha256-FPApT6snyzYbMn/Am7Zxpwp5w8VZ8F6/YhwCLwDaRAw=";

  subPackages = [ "cmd/easeprobe" ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
    "-X github.com/megaease/easeprobe/global.Ver=${version}"
    "-X github.com/megaease/easeprobe/pkg/version.REPO=megaease/easeprobe"
  ];

  meta = with lib; {
    description = "Simple, standalone, and lightweight tool that can do health/status checking, written in Go";
    homepage = "https://github.com/megaease/easeprobe";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "easeprobe";
  };
}
