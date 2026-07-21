{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "radicale";
  version = "3.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-skNlk2fuUH6GGhphjr2sw4UA/l3Im8p/j52RhE3uDwE=";
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
    ]
    ++ libpass.optional-dependencies.argon2
    ++ libpass.optional-dependencies.bcrypt;

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
    changelog = "https://github.com/Kozea/Radicale/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "CalDAV and CardDAV server";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      erictapen
    ];
  };
})
