{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "gobgp";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-crruhk4Jo1TdmGWvtdJKCBucjYNEwEMbNkJ3r5hxoQA=";
  };

  vendorHash = "sha256-fGDjeWmIe0GNZTDCXDBU4b286rMdCnPgRBInLZsFWxQ=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [ "cmd/gobgp" ];

  meta = {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
})
