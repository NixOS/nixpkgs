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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "RPKI-to-Router server used at Cloudflare";
    homepage = "https://github.com/cloudflare/gortr/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stv0g ];
  };
}
