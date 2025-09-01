{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "gortr";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gortr";
    rev = "v${version}";
    hash = "sha256-W6+zCLPcORGcRJF0F6/LRPap4SNVn/oKGs21T4nSNO0=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ stv0g ];
  };
}
