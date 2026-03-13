{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nova";
  version = "3.11.10";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "nova";
    rev = "v${finalAttrs.version}";
    hash = "sha256-64IDZMdEkSxbFr0HvDHTNz5j3IFEvmEICCUZ7ldX3TE=";
  };

  vendorHash = "sha256-HzVYJeDYSfUZmnq8iJeMeydkFGlRv+aylpEmbu3okfI=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-s"
    "-w"
  ];

  meta = {
    description = "Find outdated or deprecated Helm charts running in your cluster";
    mainProgram = "nova";
    longDescription = ''
      Nova scans your cluster for installed Helm charts, then
      cross-checks them against all known Helm repositories. If it
      finds an updated version of the chart you're using, or notices
      your current version is deprecated, it will let you know.
    '';
    homepage = "https://nova.docs.fairwinds.com/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ qjoly ];
  };
})
