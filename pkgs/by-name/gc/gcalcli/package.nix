{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  libnotify,
}:

python3Packages.buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "insanum";
    repo = "gcalcli";
    tag = "v${version}";
    hash = "sha256-FU1EHLQ+/2sOGeeGwONsrV786kHTFfMel7ocBcCe+rI=";
  };

  updateScript = nix-update-script { };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace gcalcli/argparsers.py \
      --replace-fail "'notify-send" "'${lib.getExe libnotify}"
  '';

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    argcomplete
    babel
    gflags
    google-api-python-client
    google-auth-oauthlib
    httplib2
    libnotify
    parsedatetime
    platformdirs
    pydantic
    python-dateutil
    truststore
    uritemplate
    vobject
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
