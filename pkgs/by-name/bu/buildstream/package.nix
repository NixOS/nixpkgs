{
  python3Packages,
  fetchFromGitHub,
  lzip,
  patch,
  bubblewrap,
  fuse3,
  lib,
  buildbox,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "buildstream";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "buildstream";
    tag = version;
    hash = "sha256-6a0VzYO5yj7EHvAb0xa4xZ0dgBKjFcwKv2F4o93oahY=";
  };

  build-system = with python3Packages; [
    setuptools
    pdm-pep517
    setuptools-scm
    cython
  ];

  dependencies = with python3Packages; [
    click
    dulwich
    grpcio
    jinja2
    markupsafe
    packaging
    pluginbase
    protobuf
    psutil
    pyroaring
    requests
    ruamel-yaml
    ruamel-yaml-clib
    tomlkit
    ujson
  ];

  buildInputs = [
    buildbox
    fuse3
    lzip
    patch
  ];

  nativeBuildInputs = with python3Packages; [
    bubblewrap
    buildbox
  ];

  propagatedBuildInputs = [
    buildbox
  ];

  pythonImportsCheck = [ "buildstream" ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-timeout
    python3Packages.pytest-env
    python3Packages.pytest-datafiles
    python3Packages.pyftpdlib
    python3Packages.pexpect
    versionCheckHook
  ];

  versionCheckProgram = "${placeholder "out"}/bin/bst";
  versionCheckProgramArg = "--version";

  meta = {
    description = "BuildStream is a powerful software integration tool that allows developers to automate the integration of software components including operating systems, and to streamline the software development and production process.";
    downloadPage = "https://buildstream.build/install.html";
    homepage = "https://buildstream.build/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "bst";
    maintainers = with lib.maintainers; [ shymega ];
  };
}
