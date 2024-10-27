{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gortr";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W6+zCLPcORGcRJF0F6/LRPap4SNVn/oKGs21T4nSNO0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = {
    description = "RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stv0g ];
  };
}
