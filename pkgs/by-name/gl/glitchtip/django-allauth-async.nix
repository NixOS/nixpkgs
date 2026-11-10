{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  python,

  # build-system
  setuptools,
  setuptools-scm,

  # build-time dependencies
  gettext,

  # dependencies
  aiohttp,
  asgiref,
  django,

  # optional-dependencies
  fido2,
  oauthlib,
  python3-openid,
  python3-saml,
  requests,
  pyjwt,
  qrcode,

  # tests
  django-ninja,
  djangorestframework,
  pillow,
  psycopg2,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-allauth-async";
  version = "65.19.1.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-allauth-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLD1FHR4bhwtW28pid+9K+VOsTxvHyXNQ3UFIjdkJag=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    asgiref
    django
  ];

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} -m django compilemessages
  '';

  optional-dependencies = {
    headless = [
      pyjwt
    ]
    ++ pyjwt.optional-dependencies.crypto;
    headless-spec = [ pyyaml ];
    idp-oidc = [
      oauthlib
      pyjwt
    ]
    ++ pyjwt.optional-dependencies.crypto;
    mfa = [
      fido2
      qrcode
    ];
    openid = [ python3-openid ];
    saml = [ python3-saml ];
    socialaccount = [
      oauthlib
      requests
      pyjwt
    ]
    ++ pyjwt.optional-dependencies.crypto;
    steam = [ python3-openid ];
  };

  pythonImportsCheck = [ "allauth_async" ];

  nativeCheckInputs = [
    django-ninja
    djangorestframework
    pillow
    psycopg2
    pytest-asyncio
    pytest-django
    pytestCheckHook
    pyyaml
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestPaths = [
    # flaky
    "allauth_async/tests/mfa/test_totp.py::test_activate_authenticate_deactivate"
    "allauth_async/tests/mfa/test_totp.py::test_signals_on_activate_and_deactivate"
    "allauth_async/tests/mfa/test_trust.py::test_trust_stage_parity"
  ];

  meta = {
    description = "Native-asyncio twin of allauth's authentication flows for ASGI applications";
    downloadPage = "https://gitlab.com/glitchtip/django-allauth-async/";
    homepage = "https://allauth.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felbinger
    ];
  };
})
