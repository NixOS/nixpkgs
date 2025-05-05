{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "parlay";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "snyk";
    repo = "parlay";
    rev = "v${version}";
    hash = "sha256-i7g0l+Q4VpBINK/HgIsl3wuxT2YoSqK08AJRxeVEzyo=";
  };

  vendorHash = "sha256-X/cgNdsUG0Ics/DCk1HOdzez9Ewwm1odFL1EiyFv1Sw=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enriches SBOMs with data from third party services";
    homepage = "https://github.com/snyk/parlay";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kiike
    ];
    mainProgram = "parlay";
    platforms = lib.platforms.unix;
  };
}
