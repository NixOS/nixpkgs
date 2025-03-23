{
  lib,
  fetchFromGitHub,
  python3,
  git,
  git-filter-repo,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-relevant-history";
  version = "2022-09-15";
  src = fetchFromGitHub {
    owner = "rainlabs-eu";
    repo = pname;
    rev = "84552324d7cb4790db86282fc61bf98a05b7a4fd";
    hash = "sha256-46a6TR1Hi3Lg2DTmOp1aV5Uhd4IukTojZkA3TVbTnRY=";
  };
  propagatedBuildInputs = [
    git
    git-filter-repo
    python3.pkgs.docopt
  ];

  meta = with lib; {
    description = "Extract only relevant history from git repo";
    homepage = "https://github.com/rainlabs-eu/git-relevant-history";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.bendlas ];
    mainProgram = "git-relevant-history";
  };
}
