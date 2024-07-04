{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parlay";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${version}";
    hash = "sha256-ztBGun1YFiF96G7R9SR8xyb3vw9oOYaxkHvpQ3SVMb4=";
  };

  vendorHash = "sha256-vovWLoa2JWjKsMAQ0XzNiClOpOrwN+aiVb83YWSoOio=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enriches SBOMs with data from third party services ";
    homepage = "https://github.com/snyk/parlay";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "parlay";
    platforms = lib.platforms.unix;
  };
}
