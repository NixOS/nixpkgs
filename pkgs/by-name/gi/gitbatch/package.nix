{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "gitbatch";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = "gitbatch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ovmdbyPRSebwmW6AW55jBgBKaNdY6w5/wrpUF2cMKw8=";
  };

  vendorHash = "sha256-wwpaJO5cXMsvqFXj+qGiIm4zg/SL4YCm2mNnG/qdilw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeCheckInputs = [
    git # required by unit tests
  ];

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  checkFlags = [
    # Disable tests requiring network access to gitlab.com
    "-skip=Test(Run|Start|(Fetch|Pull)With(Go|)Git)"
  ];

  meta = {
    description = "Running git UI commands";
    homepage = "https://github.com/isacikgoz/gitbatch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    platforms = with lib.platforms; linux;
    mainProgram = "gitbatch";
  };
})
