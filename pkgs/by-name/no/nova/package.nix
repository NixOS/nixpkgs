{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nova";
  version = "3.11.4";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "nova";
    rev = "v${version}";
    hash = "sha256-0jDmuZqq3NNTekmu6saUjCuc0G0tj10hV0tRjwkYQg4=";
  };

  vendorHash = "sha256-qXYhj3vVS6MoU4JPEDIxDZNDM2j/4Nxp6ZSlqUYVjMA=";

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
