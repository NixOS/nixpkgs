{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "gh-poi";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "seachicken";
    repo = "gh-poi";
    rev = "v${version}";
    hash = "sha256-QpUZxho9hzmgbCFgNxwwKi6hhfyqc4b/JYKH3rP4Eb8=";
  };

  ldflags = [ "-s" "-w" ];

  vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";

  # Skip checks because some of test suites require fixture.
  # See: https://github.com/seachicken/gh-poi/blob/v0.9.8/.github/workflows/contract-test.yml#L28-L29
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
