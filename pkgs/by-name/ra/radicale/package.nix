{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "radicale";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xeNiLbh2/OsivbQ9RKGCqqs/VPpBtEjj4sqXcQ9p9pw=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies =
    with python3.pkgs;
    [
      defusedxml
      libpass
      vobject
      pika
      requests
      ldap3
      python-pam
    ]
    ++ libpass.optional-dependencies.argon2
    ++ libpass.optional-dependencies.bcrypt;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    waitress
  ];

  # skip tests which try to measure how long something takes; makes the build fail sometimes
  disabledTests = [ "delay" ];

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = {
    homepage = "https://radicale.org/v3.html";
    changelog = "https://github.com/Kozea/Radicale/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "CalDAV and CardDAV server";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      erictapen
    ];
  };
})
