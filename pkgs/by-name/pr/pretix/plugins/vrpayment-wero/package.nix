{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pretix-plugin-build,
  setuptools,

  # tests
  pretix,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pretix-vrpayment-wero";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-vrpayment-wero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OI0+BS3G6n5FAPhOD3pf1iKmr88HtaUARb7OB5MWWC4=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  nativeCheckInputs = [
    pretix
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=pretix.testutils.settings
  '';

  pythonImportsCheck = [
    "pretix_vrpayment_wero"
  ];

  meta = {
    changelog = "https://github.com/pretix/pretix-vrpayment-wero/releases/tag/${finalAttrs.src.tag}";
    description = "Accept WERO payments through VR Payment, the payment service provider of Volksbanken Raiffeisenbanken";
    homepage = "https://github.com/pretix/pretix-vrpayment-wero";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
