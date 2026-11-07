{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "storj-uplink";
  version = "1.166.1";

  src = fetchFromGitHub {
    owner = "storj";
    repo = "storj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hnhuMtZ+1YnpkZuNX/s1ZISecx7tDwtWss3Kw37Tfmw=";
  };

  subPackages = [ "cmd/uplink" ];

  vendorHash = "sha256-7JmI3yUSwxQZUXDUYg98GuPnAb1LPrrQNQJ59IFpZd4=";

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
