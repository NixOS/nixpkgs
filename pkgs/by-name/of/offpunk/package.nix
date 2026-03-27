{
  fetchFromSourcehut,
  file,
  gettext,
  installShellFiles,
  less,
  lib,
  python3Packages,
  timg,
  versionCheckHook,
  xdg-utils,
  xsel,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "offpunk";
  version = "3.1";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RwigItHVNsgq6k3O8YrSMFBaZMJwJSzB6dfnNiYsefY=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    gettext
    installShellFiles
  ];

  dependencies = [
    file
    less
    timg
    xdg-utils
    xsel
  ]
  ++ (with python3Packages; [
    beautifulsoup4
    chardet
    cryptography
    feedparser
    hatch-requirements-txt
    readability-lxml
    requests
    setproctitle
  ]);

  /*
    False positive from pythonRuntimeDepsCheckHook:
      - "bs4" is the import name for beautifulsoup4 (not the PyPI
        package name)
      - "file" refers to the system `file` binary, not a Python
        package
  */
  pythonRemoveDeps = [
    "bs4"
    "file"
  ];

  postInstall = ''
    installManPage man/*.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://git.sr.ht/~lioploum/offpunk/tree/v${finalAttrs.version}/item/CHANGELOG";
    description = "CLI and offline-first smolnet browser/feed reader";
    longDescription = ''
      Offpunk allows you to browse the Web, Gemini, Gopher and
      subscribe to RSS feeds without leaving your terminal and while
      being offline.

      The goal of Offpunk is to be able to synchronise your content
      once (a day, a week, a month) and then browse/organise it while
      staying disconnected.
    '';
    homepage = "https://offpunk.net";
    license = lib.licenses.agpl3Plus;
    mainProgram = "offpunk";
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
})
