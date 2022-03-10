{ lib, stdenv, buildPythonApplication, fetchFromGitHub, pythonOlder,
  attrs, aiohttp, appdirs, click, keyring, Logbook, peewee, janus,
  prompt-toolkit, matrix-nio, dbus-python, pydbus, notify2, pygobject3,
  setuptools, installShellFiles, nixosTests,

  pytest, faker, pytest-aiohttp, aioresponses,

  enableDbusUi ? true
}:

buildPythonApplication rec {
  pname = "pantalaimon";
  version = "0.10.4";

  disabled = pythonOlder "3.6";

  # pypi tarball miss tests
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-X6DJHH+ZBPw7iWVMa43HvVFh+LDn6shzOU1A2uiAYL4=";
  };

  propagatedBuildInputs = [
    aiohttp
    appdirs
    attrs
    click
    janus
    keyring
    Logbook
    matrix-nio
    peewee
    prompt-toolkit
    setuptools
  ] ++ lib.optional enableDbusUi [
      dbus-python
      notify2
      pygobject3
      pydbus
  ];

  checkInputs = [
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
