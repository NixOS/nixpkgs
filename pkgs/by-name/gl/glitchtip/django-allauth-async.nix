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
  requests-oauthlib,
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
  version = "65.16.1.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "glitchtip";
    repo = "django-allauth-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0eUqIbQT4+8qH3oiGrXUzXBzy9iE5vhn00xdUBCGDh0=";
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
      requests
      requests-oauthlib
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

  disabledTests = [
    # Tests require network access
    "test_login"
  ];

  meta = {
    description = "Native-asyncio twin of allauth's authentication flows for ASGI applications";
    downloadPage = "https://gitlab.com/glitchtip/django-allauth-async/";
    homepage = "https://allauth.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      defelo
      felbinger
    ];
  };
})
