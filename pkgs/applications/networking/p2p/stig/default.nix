{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
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

  # urwidtrees 1.0.3 is requested by the developer because 1.0.2 (which is packaged
  # in nixpkgs) is not uploaded to pypi and 1.0.1 has a problematic `setup.py`.
  # As long as we don't have any problems installing it, no special features / specific bugs
  # were fixed in 1.0.3 that aren't available in 1.0.2 are used by stig.
  # See https://github.com/rndusr/stig/issues/120
  postPatch = ''
    substituteInPlace setup.py \
      --replace "urwidtrees>=1.0.3dev0" "urwidtrees"
  '';

  buildInputs = with python3.pkgs; [
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

  checkInputs = with python3.pkgs; [
    asynctest
    pytest
  ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
