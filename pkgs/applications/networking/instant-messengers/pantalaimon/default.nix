{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
  enableDbusUi ? true,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "pantalaimon";
  version = "0.10.6";
  pyproject = true;

  # pypi tarball miss tests
  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "pantalaimon";
    rev = version;
    hash = "sha256-g+ZWarZnjlSOpD75yf53Upqj1qDlil7pdbfEsMAsjh0=";
  };

  build-system = [
    installShellFiles
  ]
  ++ (with python3Packages; [
    setuptools
  ]);

  pythonRelaxDeps = [
    "matrix-nio"
  ];

  dependencies =
    with python3Packages;
    [
      aiohttp
      attrs
      cachetools
      click
      janus
      keyring
      logbook
      (matrix-nio.override { withOlm = true; })
      peewee
      platformdirs
      prompt-toolkit
    ]
    ++ lib.optionals enableDbusUi optional-dependencies.ui;

  optional-dependencies.ui = with python3Packages; [
    dbus-python
    notify2
    pygobject3
    pydbus
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      aioresponses
      faker
      pytest-aiohttp
      pytestCheckHook
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  nativeBuildInputs = lib.optionals enableDbusUi [
    wrapGAppsHook3
  ];

  dontWrapGApps = enableDbusUi;
  makeWrapperArgs = lib.optionals enableDbusUi [
    "\${gappsWrapperArgs[@]}"
  ];

  # darwin has difficulty communicating with server, fails some integration tests
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall = ''
    installManPage docs/man/*.[1-9]
  '';

  passthru.tests = {
    inherit (nixosTests) pantalaimon;
  };

  meta = with lib; {
    description = "End-to-end encryption aware Matrix reverse proxy daemon";
    homepage = "https://github.com/matrix-org/pantalaimon";
    license = licenses.asl20;
    maintainers = with maintainers; [ valodim ];
  };
}
