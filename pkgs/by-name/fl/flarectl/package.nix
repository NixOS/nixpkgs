{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-9pPDoXYZCcMnusBfQ1PQ8l/ZFvPNTOA8dRJALXY1Kho=";
  };

  vendorHash = "sha256-U6ogqAweU2DZb26Ct4K/1TnCGRn//p11nVkFKzC+tj0=";

  subPackages = [ "cmd/flarectl" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "CLI application for interacting with a Cloudflare account";
    homepage = "https://github.com/cloudflare/cloudflare-go";
    changelog = "https://github.com/cloudflare/cloudflare-go/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "flarectl";
  };
}
