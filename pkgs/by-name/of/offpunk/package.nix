{
  lib,
  python3Packages,
  fetchFromSourcehut,
  file,
  installShellFiles,
  less,
  offpunk,
  testers,
  timg,
  xdg-utils,
  xsel,
}:

python3Packages.buildPythonApplication rec {
  pname = "offpunk";
  version = "2.7.1";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${version}";
    hash = "sha256-+Mbe1VLeF8Adf7bgVnbzvcWdPB4PXakCD9gO35jAYBY=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = [
    file
    less
    timg
    xdg-utils
    xsel
  ]
  ++ (with python3Packages; [
    beautifulsoup4
    chardet
    cryptography
    feedparser
    readability-lxml
    requests
    setproctitle
  ]);

  postInstall = ''
    installManPage man/*.1
  '';

  passthru.tests.version = testers.testVersion { package = offpunk; };

  meta = {
    description = "Command-line and offline-first smolnet browser/feed reader";
    homepage = src.meta.homepage;
    license = lib.licenses.agpl3Plus;
    mainProgram = "offpunk";
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
}
