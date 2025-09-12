{
  lib,
  fetchFromGitHub,
  python3Packages,
  git,
}:

python3Packages.buildPythonApplication {
  pname = "git-bars";
  version = "0-unstable-2023-08-08";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "git-bars";
    rev = "f15fbc15345d9ef021e5a9b278e352bb532dcee8";
    hash = "sha256-jHP6LqhUQv6hh97tSXAdOruWdtp2FXM6ANlpWoA+fHQ=";
  };

  propagatedBuildInputs = [
    git
    python3Packages.setuptools
  ];

  meta = with lib; {
    homepage = "https://github.com/knadh/git-bars";
    description = "Utility for visualising git commit activity as bars on the terminal";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "git-bars";
  };
}
