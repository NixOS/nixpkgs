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
  version = "2.8";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${version}";
    hash = "sha256-s/pEN7n/g9o8a/hYTC39PgbBLyCUwN5LIggqUSMKRS4=";
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
