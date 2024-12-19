{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "flarectl";
  version = "0.112.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${version}";
    hash = "sha256-HdbeGlkOFV1ebP0zylFttfREXECJhUDpta3FTQXtYCE=";
  };

  vendorHash = "sha256-TMQCJmCh0UuDdd8aenA9v2VnEISb2JX2LBUgTk0n98w=";

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
