{ lib, buildGoModule, fetchFromGitHub, go-bindata }:

buildGoModule rec {
  pname = "waypoint";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iGR2N1ZYA5G9K2cpfrwWRhSEfehRshx157ot1yq15AY=";
  };

  deleteVendor = true;
  vendorSha256 = "sha256-ArebHOjP3zvpASVAoaPXpSbrG/jq+Jbx7+EaQ1uHSVY=";

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
