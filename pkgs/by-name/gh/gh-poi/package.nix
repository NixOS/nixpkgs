{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "gh-poi";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GFJWZBVRE6tz033NI5zcJIs3ziVa1KoPggKn/o65mDE=";
  };

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-o3ys+Em27sx3VS3AQIP7G/tWRiBlPnvBq37jLtj9QVQ=";

  # Skip checks because some of test suites require fixture.
  # See: https://github.com/seachicken/gh-poi/blob/v0.17.0/.github/workflows/contract-test.yml#L28-L29
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
