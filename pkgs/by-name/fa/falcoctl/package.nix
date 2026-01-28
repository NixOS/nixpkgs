{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "falcoctl";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2vAW2Hro8xIpngjVgOD+PQzy/Y+jdpBSp5olXAVQKHs=";
  };

  vendorHash = "sha256-VI+PLtmFVwctLlX4k3m20NOXuhQCZoBmA5rqK1/UG7M=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/falcosecurity/falcoctl/cmd/version.semVersion=${finalAttrs.version}"
  ];

  # require network
  doCheck = false;

  meta = {
    description = "Administrative tooling for Falco";
    mainProgram = "falcoctl";
    homepage = "https://github.com/falcosecurity/falcoctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      kranurag7
      LucaGuerra
    ];
  };
})
