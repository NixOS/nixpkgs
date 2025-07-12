{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nova";
  version = "3.11.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "nova";
    rev = "v${version}";
    hash = "sha256-jR9fp5H4reVh65pVLYxBURYNiuMP8eOC9+gYpPT9nvk=";
  };

  vendorHash = "sha256-+cw2NclPLT9S1iakK2S5uc+nFE84MIl6QOH/L0kgoHE=";

  ldflags = [
    "-X main.version=${version}"
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Find outdated or deprecated Helm charts running in your cluster";
    mainProgram = "nova";
    longDescription = ''
      Nova scans your cluster for installed Helm charts, then
      cross-checks them against all known Helm repositories. If it
      finds an updated version of the chart you're using, or notices
      your current version is deprecated, it will let you know.
    '';
    homepage = "https://nova.docs.fairwinds.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
