{ lib, stdenv
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "stig";
  # This project has a different concept for pre release / alpha,
  # Read the project's README for details: https://github.com/rndusr/stig#stig
  version = "0.12.2a0";

  src = fetchFromGitHub {
    owner = "rndusr";
    repo = "stig";
    rev = "v${version}";
    sha256 = "0sk4vgj3cn75nyrng2d6q0pj1h968kcmbpr9sv1lj1g8fc7g0n4f";
  };

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

  nativeCheckInputs = with python3Packages; [
    asynctest
    pytestCheckHook
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export LC_ALL=C
  '';

  pytestFlagsArray = [
    "tests"
    # TestScrollBarWithScrollable.test_wrapping_bug fails
    "--deselect=tests/tui_test/scroll_test.py::TestScrollBarWithScrollable::test_wrapping_bug"
    # https://github.com/rndusr/stig/issues/214
    "--deselect=tests/completion_test/classes_test.py::TestCandidates::test_candidates_are_sorted_case_insensitively"
  ] ++ lib.optionals stdenv.isDarwin [
    "--deselect=tests/client_test/ttypes_test.py::TestTimestamp::test_string__month_day_hour_minute_second"
    "--deselect=tests/client_test/aiotransmission_test/api_torrent_test.py"
    "--deselect=tests/client_test/aiotransmission_test/rpc_test.py"
  ];

  meta = with lib; {
    description = "TUI and CLI for the BitTorrent client Transmission";
    homepage = "https://github.com/rndusr/stig";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
  };
}
