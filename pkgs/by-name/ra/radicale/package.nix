{
  lib,
  fetchFromGitHub,
  nixosTests,
  python3,
  infcloud ? null,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "radicale";
  version = "3.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9xm/2sTDLiX7PqJ+juaIVpwbJ4r/jyBEFE/QWtl9Yo=";
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

  # Since 3.5.0 Radicale allows for an optionally bundled InfCloud web client,
  # no need for RadicaleInfcloud.
  postInstall = lib.optionalString (infcloud != null) ''
    ln -s '${infcloud}' $out/${python3.sitePackages}/radicale/web/internal_data/infcloud
  '';

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
