{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  libnotify,
}:

python3Packages.buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "gcalcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-roHMWUwklLMNhLJANsAeBKcSX1Qk47kH5A3Y8SuDrmg=";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace gcalcli/argparsers.py \
      --replace-fail "'notify-send" "'${lib.getExe libnotify}"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    python-dateutil
    gflags
    httplib2
    parsedatetime
    six
    vobject
    google-api-python-client
    oauth2client
    uritemplate
    libnotify
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "CLI for Google Calendar";
    mainProgram = "gcalcli";
    homepage = "https://github.com/insanum/gcalcli";
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
  };
}
