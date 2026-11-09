{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "rush-parallel";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T0uR/RPz/E8JlBnW5hTCSK/fRWC8YSptxt0rzaS/Dfo=";
  };

  vendorHash = "sha256-EnVmzHxalg6CnmNyLFklS5eYE+Yo4fQnmkyLECcuZqQ=";

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
