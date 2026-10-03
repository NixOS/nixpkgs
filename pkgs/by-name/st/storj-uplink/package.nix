{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.163.6";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HsiERZsvECIB7dSolyMHEei6HDkDeXWMz7V2sPjeXP8=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-fgeZ88J3QxUElShWA+SWeQ1zQiGPPHWayoJl+FWAKz8=";

  ldflags = [
    "-s"
    "-X storj.io/common/version.buildVersion=v${finalAttrs.version}"
    "-X storj.io/common/version.buildRelease=true"
  ];

  checkFlags = [
    "-skip=TestMove"
  ];

  # Tests fail with 'listen tcp 127.0.0.1:0: bind: operation not permitted'.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command-line tool for Storj";
    homepage = "https://storj.io";
    license = lib.licenses.agpl3Only;
    mainProgram = "uplink";
    maintainers = with lib.maintainers; [ felipeqq2 ];
  };
})
