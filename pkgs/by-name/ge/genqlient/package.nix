{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "genqlient";
  version = "0.8.1-unstable-2026-08-25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Khan";
    repo = "genqlient";
    rev = "8d029a3f38e6259fbb618a635a3c811cee8afdc4";
    hash = "sha256-AhOdnJo0F3dSCIJGiR+oUNE/254Y+wLDkCjz0uXzkkc=";
  };

  vendorHash = "sha256-uAbiX8UUq+Rv73lTjBBUdj/GMjayaetyV7FI45ee214=";

  subPackages = [ "." ];

  meta = {
    description = "GraphQL client generator for Go";
    homepage = "https://github.com/Khan/genqlient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ karitham ];
    mainProgram = "genqlient";
  };
}
