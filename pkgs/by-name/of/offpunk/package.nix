{ fetchFromSourcehut
, file
, installShellFiles
, less
, lib
, offpunk
, python3Packages
, testers
, timg
, xdg-utils
, xsel
}:

let
  pythonDependencies = with python3Packages; [
    beautifulsoup4
    chardet
    cryptography
    feedparser
    pillow
    readability-lxml
    requests
    setproctitle
  ];
  otherDependencies = [
    file
    less
    timg
    xdg-utils
    xsel
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "offpunk";
  version = "2.3";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${version}";
    hash = "sha256-Tiby+JjPc7eFQKziQFUdqcNgx9UhU4GNeRcI/aAzcvk=";
  };

  nativeBuildInputs = [ python3Packages.hatchling installShellFiles ];
  propagatedBuildInputs = otherDependencies ++ pythonDependencies;

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
    platforms = lib.platforms.linux;
  };
}
