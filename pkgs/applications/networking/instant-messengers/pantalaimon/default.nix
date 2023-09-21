{ lib, stdenv, buildPythonApplication, fetchFromGitHub, pythonOlder,
  attrs, aiohttp, appdirs, click, keyring, logbook, peewee, janus,
  prompt-toolkit, matrix-nio, dbus-python, pydbus, notify2, pygobject3,
  setuptools, installShellFiles, nixosTests,

  pytest, faker, pytest-aiohttp, aioresponses,

  enableDbusUi ? true
}:

buildPythonApplication rec {
  pname = "pantalaimon";
  version = "0.10.5";

  disabled = pythonOlder "3.6";

  # pypi tarball miss tests
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-yMhE3wKRbFHoL0vdFR8gMkNU7Su4FHbAwKQYADaaWpk=";
  };

  propagatedBuildInputs = [
    aiohttp
    appdirs
    attrs
    click
    janus
    keyring
    logbook
    matrix-nio
    peewee
    prompt-toolkit
    setuptools
  ]
  ++ matrix-nio.optional-dependencies.e2e
  ++ lib.optionals enableDbusUi [
      dbus-python
      notify2
      pygobject3
      pydbus
  ];

  nativeCheckInputs = [
    pytest
    faker
    pytest-aiohttp
    aioresponses
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  # darwin has difficulty communicating with server, fails some integration tests
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    pytest
  '';

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
