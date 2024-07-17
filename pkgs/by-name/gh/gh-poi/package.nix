{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gh-poi";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${version}";
    hash = "sha256-0QzCXja1UXPEC8JQIXH9Dl4PPKzqWgIy13FCYxEqggA=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";

  # Skip checks because some of test suites require fixture.
  # See: https://github.com/seachicken/gh-poi/blob/v0.9.10/.github/workflows/contract-test.yml#L28-L29
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/seachicken/gh-poi/releases/tag/${src.rev}";
    description = "GitHub CLI extension to safely clean up your local branches";
    homepage = "https://github.com/seachicken/gh-poi";
    license = licenses.mit;
    maintainers = with maintainers; [ aspulse ];
    mainProgram = "gh-poi";
  };
}
