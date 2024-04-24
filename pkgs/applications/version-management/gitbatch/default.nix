{ lib, buildGoModule, fetchFromGitHub, git }:

buildGoModule rec {
  pname = "gitbatch";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = "gitbatch";
    rev = "v${version}";
    sha256 = "sha256-ovmdbyPRSebwmW6AW55jBgBKaNdY6w5/wrpUF2cMKw8=";
  };

  vendorHash = "sha256-wwpaJO5cXMsvqFXj+qGiIm4zg/SL4YCm2mNnG/qdilw=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    git # required by unit tests
  ];

  preCheck = ''
    HOME=$(mktemp -d)
    # Disable tests requiring network access to gitlab.com
    buildFlagsArray+=("-run" "[^(Test(Run|Start|(Fetch|Pull)With(Go|)Git))]")
  '';

  meta = with lib; {
    description = "Running git UI commands";
    homepage = "https://github.com/isacikgoz/gitbatch";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
    platforms = with platforms; linux;
    mainProgram = "gitbatch";
  };
}
