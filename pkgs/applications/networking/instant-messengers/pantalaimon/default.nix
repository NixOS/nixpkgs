{ lib, stdenv, buildPythonApplication, fetchFromGitHub, pythonOlder,
  attrs, aiohttp, appdirs, click, keyring, Logbook, peewee, janus,
  prompt-toolkit, matrix-nio, dbus-python, pydbus, notify2, pygobject3,
  setuptools, fetchpatch, installShellFiles,

  pytest, faker, pytest-aiohttp, aioresponses,

  enableDbusUi ? true
}:

buildPythonApplication rec {
  pname = "pantalaimon";
  version = "0.9.2";

  disabled = pythonOlder "3.6";

  # pypi tarball miss tests
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = version;
    sha256 = "11dfv5b2slqybisq6npmrqxrzslh4bjs4093vrc05s94046d9d9n";
  };

  patches = [
    # accept newer matrix-nio versions
    (fetchpatch {
      url = "https://github.com/matrix-org/pantalaimon/commit/73f68c76fb05037bd7fe71688ce39eb1f526a385.patch";
      sha256 = "0wvqcfan8yp67p6khsqkynbkifksp2422b9jy511mvhpy51sqykl";
    })
  ];

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

  meta = with lib; {
    description = "An end-to-end encryption aware Matrix reverse proxy daemon";
    homepage = "https://github.com/matrix-org/pantalaimon";
    license = licenses.asl20;
    maintainers = with maintainers; [ valodim ];
  };
}
