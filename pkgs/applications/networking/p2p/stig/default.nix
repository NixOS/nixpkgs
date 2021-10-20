{ lib, stdenv
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "stig";
  # This project has a different concept for pre release / alpha,
  # Read the project's README for details: https://github.com/rndusr/stig#stig
  version = "0.11.2a0";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "stig";
    rev = "v${version}";
    sha256 = "05dn6mr86ly65gdqarl16a2jk1bwiw5xa6r4kyag3s6lqsv66iw8";
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

  propagatedBuildInputs = with python3Packages; [
    urwid
    urwidtrees
    aiohttp
    async-timeout
    pyxdg
    blinker
    natsort
    setproctitle
  ];

  checkInputs = with python3Packages; [
    asynctest
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export LC_ALL=C
  '';

  pytestFlagsArray = [
    "tests"
    # test_string__month_day_hour_minute_second fails on darwin
    "--deselect=tests/client_test/ttypes_test.py::TestTimestamp::test_string__month_day_hour_minute_second"
    # TestScrollBarWithScrollable.test_wrapping_bug fails
    "--deselect=tests/tui_test/scroll_test.py::TestScrollBarWithScrollable::test_wrapping_bug"
  ] ++ lib.optionals stdenv.isDarwin [
    "--deselect=tests/client_test/aiotransmission_test/api_torrent_test.py"
    "--deselect=tests/client_test/aiotransmission_test/rpc_test.py"
  ];

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
