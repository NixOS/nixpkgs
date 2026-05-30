{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "sloth";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "slok";
    repo = "sloth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/sDjefcuZZFqzEAppuDefctayfITktbpi0dHB0vu27M=";
  };

  vendorHash = "sha256-/1bZNarqCI24pm/SXtOZ+PDDTVpCdFebx6ccDSvnf5o=";

  subPackages = [ "cmd/sloth" ];

  meta = {
    description = "Easy and simple Prometheus SLO (service level objectives) generator";
    homepage = "https://sloth.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nrhtr ];
    platforms = lib.platforms.unix;
    mainProgram = "sloth";
  };
})
