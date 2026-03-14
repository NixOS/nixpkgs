{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gh-poi";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ycq5uEp+Slae1G4DXiZnjk4UvbnXoTMmpPq0Kx5AHow=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-UHkNSTRH9m6H8Wh7S7uUy5SHuGe0uAmmYuoeR76C7m0=";

  # Skip checks because some of test suites require fixture.
  # See: https://github.com/seachicken/gh-poi/blob/v0.15.3/.github/workflows/contract-test.yml#L28-L29
  doCheck = false;

  meta = {
    changelog = "https://github.com/seachicken/gh-poi/releases/tag/${finalAttrs.src.rev}";
    description = "GitHub CLI extension to safely clean up your local branches";
    homepage = "https://github.com/seachicken/gh-poi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aspulse ];
    mainProgram = "gh-poi";
  };
})
