{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mastodon-archive";
  version = "1.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kensanata";
    repo = "mastodon-backup";
    rev = "v${version}";
    hash = "sha256-yz17ddcA0U9fq1aDlPmD3OkNL6Epzdp9C7L+31yNLBc=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    html2text
    mastodon-py
    progress
  ];

  # There is no test
  doCheck = false;

  pythonImportsCheck = [ "mastodon_archive" ];

  meta = with lib; {
    description = "Utility for backing up your Mastodon content";
    mainProgram = "mastodon-archive";
    homepage = "https://alexschroeder.ch/software/Mastodon_Archive";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ julm ];
  };
}
