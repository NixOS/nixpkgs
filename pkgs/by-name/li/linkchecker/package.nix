{ lib
, fetchFromGitHub
, python3
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linkchecker";
    repo = "linkchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-E8Wv4RmAy0vbLhecsJhqE17SJiwnbmaNKz3Gkz/OUvg=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
    polib # translations
  ];

  dependencies = with python3.pkgs; [
    argcomplete
    beautifulsoup4
    dnspython
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyopenssl
    parameterized
    pytestCheckHook
  ];

  preCheck = ''
    # required for test_linkchecker
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    "TestLoginUrl"
    "test_timeit2" # flakey, and depends sleep being precise to the milisecond
    "test_html_internet" # uses network, fails on Darwin (not sure why it doesn't fail on linux)
    "test_markdown" # uses sys.version_info for conditional testing
    "test_itms_services" # uses sys.version_info for conditional testing
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Check websites for broken links";
    mainProgram = "linkchecker";
    homepage = "https://linkcheck.github.io/linkchecker/";
    changelog = "https://github.com/linkchecker/linkchecker/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg tweber ];
  };
}
