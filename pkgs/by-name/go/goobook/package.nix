{
  lib,
  fetchFromGitLab,
  docutils,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "goobook";
  version = "3.5.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "goobook";
    repo = "goobook";
    tag = version;
    hash = "sha256-gWmeRlte+lP7VP9gbPuMHwhVkx91wQ0GpQFQRLJ29h8=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  pythonRelaxDeps = [
    "google-api-python-client"
    "pyxdg"
    "setuptools"
  ];

  dependencies = with python3Packages; [
    google-api-python-client
    simplejson
    oauth2client
    setuptools
    pyxdg
  ];

  postInstall = ''
    rst2man goobook.1.rst goobook.1
    installManPage goobook.1
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "goobook" ];

  meta = {
    description = "Access your Google contacts from the command line";
    mainProgram = "goobook";
    longDescription = ''
      The purpose of GooBook is to make it possible to use your Google Contacts
      from the command-line and from MUAs such as Mutt.
      It can be used from Mutt the same way as abook.
    '';
    homepage = "https://gitlab.com/goobook/goobook";
    changelog = "https://gitlab.com/goobook/goobook/-/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
}
