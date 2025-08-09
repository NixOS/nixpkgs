{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mastodon-archive";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kensanata";
    repo = "mastodon-backup";
    rev = "v${version}";
    hash = "sha256-b4bYQshz7mwxEfpRYV7ze4C8hz58R9cVp58wHvGFb0A=";
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
