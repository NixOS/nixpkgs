{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rush-parallel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sdXvgdqwhIH8rr/3UudkuQpOL9MZqMzyrbvMwuHz6Og=";
  };

  vendorHash = "sha256-bbW3FgW4m2/gjAprO+GkgqnktsWmuaPq8Qt9FDfBSx4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Cross-platform command-line tool for executing jobs in parallel";
    homepage = "https://github.com/shenwei356/rush";
    changelog = "https://github.com/shenwei356/rush/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "rush-parallel";
  };
})
