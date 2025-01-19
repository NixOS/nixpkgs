{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gokey";
  version = "0.1.3";

  patches = [ ./version.patch ];

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "gokey";
    tag = "v${version}";
    hash = "sha256-pvtRSWq/vXlyUShb61aiDlis9AiQnrA2PWycr1Zw0og=";
  };

  vendorHash = "sha256-qlP2tI6QQMjxP59zaXgx4mX9IWSrOKWmme717wDaUEc=";

  meta = {
    homepage = "https://github.com/cloudflare/gokey";
    description = "Vault-less password store";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.confus ];
    mainProgram = "gokey";
  };
}
