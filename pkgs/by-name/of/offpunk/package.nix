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
,
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
python3Packages.buildPythonPackage rec {
  pname = "offpunk";
  version = "2.1";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.7";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${version}";
    hash = "sha256-IFqasTI2dZCauLUAq6/rvwkfraVK7SGUXpHCPEgSPGk=";
  };

  nativeBuildInputs = [ python3Packages.hatchling installShellFiles ];
  propagatedBuildInputs = otherDependencies ++ pythonDependencies;

  postInstall = ''
    installManPage man/*.1
  '';

  passthru.tests.version = testers.testVersion { package = offpunk; };

  meta = with lib; {
    description = "An Offline-First browser for the smolnet ";
    homepage = src.meta.homepage;
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
    license = licenses.agpl3Plus;
  };
}
