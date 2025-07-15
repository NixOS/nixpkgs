{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gh-poi";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${version}";
    hash = "sha256-bbmNzxGRg7nKfB8xu90ZkKrhWwY24G6h8TW07f9IpTY=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-ciOJpVqSPJJLX/sqrztqB3YSoMUrEnn52gGddE80rV0=";

  # Skip checks because some of test suites require fixture.
  # See: https://github.com/seachicken/gh-poi/blob/v0.14.0/.github/workflows/contract-test.yml#L28-L29
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
