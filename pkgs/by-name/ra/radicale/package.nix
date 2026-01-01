{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
<<<<<<< HEAD
  version = "3.5.10";
=======
  version = "3.5.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tLBWPWkSGI7vQIGo9FIwCEgHWPlrs1q70CsAWQn9sEs=";
=======
    hash = "sha256-kgtNk+MXanYB0RyNncfM3K/HJZlScat7RDuoclu5/i0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
