{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.163.4";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SJCFlKclEJ5PSI6JJ2cD0M3FmGu/OuHhyLhtxlz7D/M=";
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
