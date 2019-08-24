{ lib
, fetchFromGitHub
, python
}:

python.pkgs.buildPythonApplication rec {
  pname = "stig";
  # This project has a different concept for pre release / alpha,
  # Read the project's README for details: https://github.com/rndusr/stig#stig
  version = "0.10.1a";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "stig";
    rev = "v${version}";
    sha256 = "076rlial6h1nhwdxf1mx5nf2zld5ci43cadj9wf8xms7zn8s6c8v";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "urwidtrees>=1.0.3dev0" "urwidtrees"
  '';

  with python3.pkgs; propagatedBuildInputs = [
    urwid
    urwidtrees
    aiohttp
    async-timeout
    pyxdg
    blinker
    natsort
    maxminddb
    setproctitle
  ];

  checkInputs = [
    asynctest
    pytest
  ];

  checkPhase = ''
    pytest --exitfirst tests
  '';

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
