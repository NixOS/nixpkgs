{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "flarectl";
  version = "0.116.0";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cloudflare-go";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DibRQmvwe58O1pcelx37fv3WFlWDcEbWeg+sJlxzDMU=";
  };

  vendorHash = "sha256-f+bNNwbTj348JJJLST2j7h8/A79qzvGlf8MjldVvtGU=";

  subPackages = [ "cmd/flarectl" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI application for interacting with a Cloudflare account";
    homepage = "https://github.com/cloudflare/cloudflare-go";
    changelog = "https://github.com/cloudflare/cloudflare-go/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jmbaur ];
    mainProgram = "flarectl";
  };
})
