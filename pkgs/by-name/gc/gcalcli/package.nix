{
  stdenv,
  lib,
  fetchFromGitHub,
  python3Packages,
  libnotify,
}:

python3Packages.buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "gcalcli";
    rev = "refs/tags/v${version}";
    hash = "sha256-X9sgnujHMbmrt7cpcBOvTycIKFz3G2QzNDt3me5GUrQ=";
  };

  postPatch =
    ''
      # dev dependencies
      substituteInPlace pyproject.toml \
        --replace-fail "\"google-api-python-client-stubs\"," "" \
        --replace-fail "\"types-python-dateutil\"," "" \
        --replace-fail "\"types-requests\"," "" \
        --replace-fail "\"types-vobject\"," ""
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace gcalcli/argparsers.py \
        --replace-fail "'notify-send" "'${lib.getExe libnotify}"
    '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    argcomplete
    python-dateutil
    gflags
    httplib2
    parsedatetime
    vobject
    google-api-python-client
    google-auth-oauthlib
    uritemplate
    libnotify
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  meta = {
    description = "CLI for Google Calendar";
    mainProgram = "gcalcli";
    homepage = "https://github.com/insanum/gcalcli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nocoolnametom ];
  };
}
