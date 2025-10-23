{
  lib,
  fetchFromGitHub,
  python3Packages,
  testers,
  stig,
}:

python3Packages.buildPythonApplication rec {
  pname = "stig";
  # This project has a different concept for pre release / alpha,
  # Read the project's README for details: https://github.com/rndusr/stig#stig
  version = "0.14.0a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "stig";
    rev = "v${version}";
    hash = "sha256-wColVJBr5oGYpN0RCh716qxKuaEhKxfl95cktZl9zMk=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    urwid
    urwidtrees
    aiohttp
    async-timeout
    pyxdg
    blinker
    natsort
    setproctitle
  ];

  pythonRelaxDeps = [
    # relax urwidtrees==1.0.3
    "urwidtrees"
  ];

  # According to the upstream author,
  # stig no longer has working tests
  # since asynctest (former test dependency) got abandoned.
  # See https://github.com/rndusr/stig/issues/206#issuecomment-2669636320
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = stig;
    command = "stig -v";
    version = "stig version ${version}";
  };

  meta = {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
