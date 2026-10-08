{
  lib,
  fetchFromGitLab,
  docutils,
  installShellFiles,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "goobook";
  version = "3.5.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "goobook";
    repo = "goobook";
    tag = finalAttrs.version;
    hash = "sha256-hBO3HfRtSZ0cN+QnK33zVZlp2/Ws265ddCuZSPBOlYs=";
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
    "google-auth-httplib2"
    "pyxdg"
    "setuptools"
    "simplejson"
  ];

  dependencies = with python3Packages; [
    google-api-python-client
    google-auth
    google-auth-httplib2
    google-auth-oauthlib
    simplejson
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
    changelog = "https://gitlab.com/goobook/goobook/-/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
