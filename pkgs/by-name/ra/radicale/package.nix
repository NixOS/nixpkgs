{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${version}";
    hash = "sha256-+vYLBd4psPxL2NkH8zriRpLUGK6cWrrkJyV230LePVE=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies =
    with python3.pkgs;
    [
      defusedxml
      passlib
      vobject
      pika
      requests
      pytz # https://github.com/Kozea/Radicale/issues/816
      ldap3
    ]
    ++ passlib.optional-dependencies.bcrypt;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    waitress
  ];

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = {
    homepage = "https://radicale.org/v3.html";
    changelog = "https://github.com/Kozea/Radicale/blob/${src.tag}/CHANGELOG.md";
    description = "CalDAV and CardDAV server";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      erictapen
    ];
  };
}
