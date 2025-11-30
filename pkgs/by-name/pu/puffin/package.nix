{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "puffin";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "siddhantac";
    repo = "puffin";
    rev = "v${version}";
    hash = "sha256-cXhnCCg5A/G/FKWfCpq130qSD1iTGpgidqzGGnIPqO8=";
  };

  vendorHash = "sha256-ZxAqR3D5VUtbntktrpnywPG3m9rq1utO4fdum0Qe6TU=";

  meta = {
    description = "Beautiful terminal dashboard for hledger";
    homepage = "https://github.com/siddhantac/puffin";
    license = lib.licenses.mit;
    mainProgram = "puffin";
    maintainers = with lib.maintainers; [ renesat ];
  };
}
