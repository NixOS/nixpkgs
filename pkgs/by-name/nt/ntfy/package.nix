{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  withMatrix ? true,
  withSlack ? true,
  withEmoji ? true,
  withPid ? true,
  withDbus ? stdenv.hostPlatform.isLinux,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ntfy";
  version = "2.7.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EIhoZ2tFJQOc5PyRCazwRhldFxQb65y6h+vYPwV7ReE=";
  };

  postPatch = ''
    # We disable the Darwin specific things because it relies on pyobjc, which we don't have.
    substituteInPlace setup.py \
      --replace-fail "':sys_platform == \"darwin\"'" "'darwin'"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    (
      [
        requests
        ruamel-yaml
        appdirs
        ntfy-webpush
      ]
      ++ lib.optionals withMatrix [
        matrix-client
      ]
      ++ lib.optionals withSlack [
        slack-sdk
      ]
      ++ lib.optionals withEmoji [
        emoji
      ]
      ++ lib.optionals withPid [
        psutil
      ]
      ++ lib.optionals withDbus [
        dbus-python
      ]
    );

  nativeCheckInputs = with python3Packages; [
    mock
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: {'backends': ['default']} != {}
    "test_default_config"

    # sleekxmpp was deprecated in favor of slixmpp
    "test_xmpp"
  ];

  disabledTestPaths = [
    "tests/test_xmpp.py"
  ];

  pythonImportsCheck = [ "ntfy" ];

  meta = {
    changelog = "https://github.com/dschep/ntfy/releases/tag/${finalAttrs.src.tag}";
    description = "Utility for sending notifications, on demand and when commands finish";
    homepage = "https://ntfy.readthedocs.io/en/latest/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kamilchm ];
    mainProgram = "ntfy";
  };
})
