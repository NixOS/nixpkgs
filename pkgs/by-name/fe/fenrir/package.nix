{
  lib,
  python3Packages,
  fetchFromGitea,
  versionCheckHook,
  gitUpdater,
}:
python3Packages.buildPythonApplication rec {
  pname = "fenrir";
  version = "2025.06.07";

  src = fetchFromGitea {
    domain = "git.stormux.org";
    owner = "storm";
    repo = "fenrir";
    tag = version;
    hash = "sha256-6cPkeMnz86zYEIKcCxQtXUthjf3PJRZ+yAL6FQhxeHg=";
  };

  dependencies = with python3Packages; [
    daemonize
    evdev
    pexpect
    pyenchant
    pyperclip
    pyte
    pyudev
    pyxdg
    setproctitle
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Modern, modular, flexible and fast console screen reader";
    homepage = "https://git.stormux.org/storm/fenrir";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      acuteaangle
    ];
    mainProgram = "fenrir";
  };
}
