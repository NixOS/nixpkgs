{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "castero";
  version = "0.9.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xgi";
    repo = "castero";
    rev = "v${version}";
    hash = "sha256-6/7oCKBMEcQeJ8PaFP15Xef9sQRYCpigtzINv2M6GUY=";
  };

  build-system = with python3.pkgs; [
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    requests
    grequests
    cjkwrap
    pytz
    beautifulsoup4
    lxml
    mpv
    python-vlc
  ] ++ requests.optional-dependencies.socks;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests"
  ];

  # Disable tests that are problematic with pytest
  # Check NixOS/nixpkgs#333019 for more info about these
  disabledTests = [
    "test_datafile_download"
    "test_display_get_input_str"
    "test_display_get_y_n"
  ];

  pythonImportsCheck = [
    "castero"
  ];

  # Resolve configuration tests, which access $HOME
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # Satisfy the python-mpv depedency, which is mpv within NixOS
  postPatch = ''
    substituteInPlace setup.py --replace-fail "python-mpv" "mpv"
  '';

  # VLC currently doesn't support Darwin on NixOS
  meta = with lib; {
    mainProgram = "castero";
    description = "TUI podcast client for the terminal";
    homepage = "https://github.com/xgi/castero";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ keto ];
  };
}
