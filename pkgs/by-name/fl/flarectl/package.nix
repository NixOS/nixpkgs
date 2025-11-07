{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.116.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-DibRQmvwe58O1pcelx37fv3WFlWDcEbWeg+sJlxzDMU=";
  };

  vendorHash = "sha256-f+bNNwbTj348JJJLST2j7h8/A79qzvGlf8MjldVvtGU=";

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
