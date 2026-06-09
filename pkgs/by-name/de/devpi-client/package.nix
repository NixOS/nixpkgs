{
  lib,
  devpi-server,
  git,
  glibcLocales,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "devpi-client";
  version = "7.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devpi";
    repo = "devpi";
    tag = "client-${finalAttrs.version}";
    hash = "sha256-rAku3oHcmzFNA/MP/64382gCTgqopwjjy4S4HTEFZiY=";
  };

  sourceRoot = "${finalAttrs.src.name}/client";

  build-system = with python3.pkgs; [
    setuptools
    setuptools-changelog-shortener
  ];

  buildInputs = [ glibcLocales ];

  dependencies = with python3.pkgs; [
    build
    check-manifest
    devpi-common
    iniconfig
    pkginfo
    pluggy
    platformdirs
    requests
  ];

  nativeCheckInputs = [
    devpi-server
    git
  ]
  ++ (with python3.pkgs; [
    mercurial
    mock
    packaging-legacy
    pypitoken
    pytestCheckHook
    sphinx
    virtualenv
    webtest
    wheel
  ]);

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlags = [
    # --fast skips tests which try to start a devpi-server improperly
    "--fast"
  ];

  env.LC_ALL = "en_US.UTF-8";

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "devpi" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Client for devpi, a pypi index server and packaging meta tool";
    homepage = "http://doc.devpi.net";
    changelog = "https://github.com/devpi/devpi/blob/client-${finalAttrs.version}/client/CHANGELOG";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lewo
      makefu
    ];
    mainProgram = "devpi";
  };
})
