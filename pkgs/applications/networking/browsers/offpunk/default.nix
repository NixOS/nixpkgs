{
  fetchFromSourcehut,
  installShellFiles,
  less,
  lib,
  offpunk,
  python3Packages,
  testers,
  timg,
  xdg-utils,
  xsel,
}:

let
  pythonDependencies = with python3Packages; [
    beautifulsoup4
    cryptography
    feedparser
    pillow
    readability-lxml
    requests
    setproctitle
  ];
  otherDependencies = [
    less
    timg
    xdg-utils
    xsel
  ];
in
python3Packages.buildPythonPackage rec {
  pname = "offpunk";
  version = "1.9";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${version}";
    sha256 = "sha256-sxX4/7jbNbLwHVfE1lDtjr/luby5zAf6Hy1RcwXZLBA=";
  };

  nativeBuildInputs = [ installShellFiles ];
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
    license = licenses.bsd2;
  };
}
