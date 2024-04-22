{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, installShellFiles
, nixosTests
, enableDbusUi ? true
}:

python3Packages.buildPythonApplication rec {
  pname = "pantalaimon";
  version = "0.10.5";
  pyproject = true;

  # pypi tarball miss tests
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "pantalaimon";
    rev = version;
    hash = "sha256-yMhE3wKRbFHoL0vdFR8gMkNU7Su4FHbAwKQYADaaWpk=";
  };

  build-system = [
    installShellFiles
  ] ++ (with python3Packages; [
    setuptools
    pythonRelaxDepsHook
  ]);

  pythonRelaxDeps = [
    "matrix-nio"
  ];

  dependencies = with python3Packages; [
    aiohttp
    appdirs
    attrs
    cachetools
    click
    janus
    keyring
    logbook
    matrix-nio
    peewee
    prompt-toolkit
  ]
  ++ matrix-nio.optional-dependencies.e2e
  ++ lib.optionals enableDbusUi optional-dependencies.ui;

  optional-dependencies.ui = with python3Packages; [
    dbus-python
    notify2
    pygobject3
    pydbus
  ];

  nativeCheckInputs = with python3Packages; [
    aioresponses
    faker
    pytest-aiohttp
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  # darwin has difficulty communicating with server, fails some integration tests
  doCheck = !stdenv.isDarwin;

  postInstall = ''
    installManPage docs/man/*.[1-9]
  '';

  passthru.tests = {
    inherit (nixosTests) pantalaimon;
  };

  meta = with lib; {
    description = "An end-to-end encryption aware Matrix reverse proxy daemon";
    homepage = "https://github.com/matrix-org/pantalaimon";
    license = licenses.asl20;
    maintainers = with maintainers; [ valodim ];
  };
}
