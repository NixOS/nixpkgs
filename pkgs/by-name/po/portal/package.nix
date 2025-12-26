{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "portal";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "SpatiumPortae";
    repo = "portal";
    rev = "v${version}";
    sha256 = "sha256-hGB82a2WirUL1Tph6EuoITOQGYA0Lo4zOeKPC46B5Qk=";
  };

  vendorHash = "sha256-SbNFi5DE3zhTUw0rsX6n+dpYcdDsaDh+zVUrfxgo/4g=";
  subPackages = [ "cmd/portal/" ];

  ldflags = [ "-s -X main.version=${version}" ]; # from: https://github.com/SpatiumPortae/portal/blob/master/Makefile#L3

  meta = {
    description = "Quick and easy command-line file transfer utility from any computer to another";
    homepage = "https://github.com/SpatiumPortae/portal";
    changelog = "https://github.com/SpatiumPortae/portal/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tennox ];
    mainProgram = "portal";
  };
}
