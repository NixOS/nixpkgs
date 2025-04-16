{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "puffin";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "siddhantac";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1qF5KOu2Se49Dw8QrSeUYIx9Yf0MCY/nbLu9IFnHxpA=";
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
