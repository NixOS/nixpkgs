{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "easeprobe";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "megaease";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XPbRtW3UIc6N1D1LKDYxgTHGVmiGDnam+r5Eg4uBa7w=";
  };

  vendorHash = "sha256-2iQJiRKt4/mBwwkjhohA1LeOfRart8WQT1bOIFuHbtA=";

  subPackages = [ "cmd/easeprobe" ];

  CGO_ENABLED = 0;

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
