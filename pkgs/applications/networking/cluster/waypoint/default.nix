{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "waypoint";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "115cak87kpfjckqgn8ws09z1w8x8l9bch9xrm29k4r0zi71xparn";
  };

  deleteVendor = true;
  vendorSha256 = "1xdari6841jp6lpjwydv19v3wafj17hmnwsa2b55iw6dysm4yxdr";

  subPackages = ["."];

  nativeBuildInputs = [ go-bindata ];

  buildPhase = ''
    CGO_ENABLED=0 go build -ldflags '-s -w -extldflags "-static"' -o ./internal/assets/ceb/ceb ./cmd/waypoint-entrypoint
    cd internal/assets
    go-bindata -pkg assets -o prod.go -tags assetsembedded ./ceb
    cd ../../
    CGO_ENABLED=0 go build -ldflags '-s -w -X github.com/hashicorp/waypoint/version.GitDescribe=v${version}' -tags assetsembedded -o ./waypoint ./cmd/waypoint
    CGO_ENABLED=0 go build -ldflags '-s -w' -tags assetsembedded -o ./waypoint-entrypoint ./cmd/waypoint-entrypoint
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv waypoint{,-entrypoint} $out/bin/
  '';

  meta = with lib; {
    description = "A tool to build, deploy, and release any application on any platform";
    longDescription = ''
      Waypoint allows developers to define their application build, deploy, and release lifecycle as code, reducing the
      time to deliver deployments through a consistent and repeatable workflow.
    '';
    homepage = "https://waypointproject.io";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ winpat jk ];
  };
}
