{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.105.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-xUITOBXBy5Jt0DFRNffX7sRhAtgUPMEJOHa2SbjM1n0=";
  };

  vendorHash = "sha256-KMCwbbDpj4QAgvKLlOPDKSlrDyf+K/tGTMM/GBlvyuc=";

  subPackages = [ "cmd/flarectl" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "CLI application for interacting with a Cloudflare account";
    homepage = "https://github.com/cloudflare/cloudflare-go";
    changelog = "https://github.com/cloudflare/cloudflare-go/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "flarectl";
  };
}
