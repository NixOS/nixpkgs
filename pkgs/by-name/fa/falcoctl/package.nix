{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "falcoctl";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BEnThboYmcZKL1o6Js8zHWvbU1OSH7BRcohBzlqNZKI=";
  };

  vendorHash = "sha256-SIEd/YVwEF4FleudzvYoOW2GnIflKMYRDEiWSv77H7o=";

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
