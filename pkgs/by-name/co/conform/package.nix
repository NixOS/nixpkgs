{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "conform";
  version = "0.1.0-alpha.33";

  src = fetchFromGitHub {
    owner = "siderolabs";
    repo = "conform";
    rev = "v${finalAttrs.version}";
    hash = "sha256-upFOgkbwndXKcu+aHjznXDmooNmzfSnlCe7NxiNzkO8=";
  };

  vendorHash = "sha256-OLZtNaPb587mjm0Ux+OA3FgjafbzMo25+DRq92uWzGQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/siderolabs/conform/internal/version.Tag=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [ git ];

  meta = {
    description = "Policy enforcement for your pipelines";
    homepage = "https://github.com/siderolabs/conform";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      jmgilman
      jk
    ];
    mainProgram = "conform";
  };
})
