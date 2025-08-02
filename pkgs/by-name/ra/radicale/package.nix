{
  fetchFromGitHub,
  fetchzip,
  lib,
  nixosTests,
  python3,
  withInfCloud ? false,
}:
let
  infcloud = lib.optionalAttrs withInfCloud fetchzip {
    url = "https://inf-it.com/open-source/download/InfCloud_0.13.1.zip";
    hash = "sha256-OEZV1KWYua4HCVqtUMoPr1Y7a0DiO+2Lgy4tIBnQULo=";
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    tag = "v${version}";
    hash = "sha256-45YLZyjQabv92izrMS1euyPhn6AATY0p+p5/GXuQxnM=";
  };

  patches = lib.optional withInfCloud ./pyproject_add_infcloud.patch;

  postPatch = lib.optionalString withInfCloud ''
    cp -r ${infcloud} radicale/web/internal_data/infcloud
  '';

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
    description =
      "CalDAV and CardDAV server" + lib.optionalString withInfCloud " with integrated infcloud";
    license =
      with lib.licenses;
      (
        [
          gpl3Plus
        ]
        ++ lib.optional withInfCloud agpl3Plus
      );
    maintainers = with lib.maintainers; [
      dotlambda
      erictapen
    ];
  };
}
