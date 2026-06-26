{
  stdenv,
  lib,
  python3Packages,
  gettext,
  qt5,
  writableTmpDirAsHomeHook,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dupeguru";
  version = "4.3.1-unstable-2026-01-06";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "arsenetar";
    repo = "dupeguru";
    rev = "16aa6c21ffc2c33d44ff4a47bfa1a623c16ed626";
    hash = "sha256-0x2ZpjaxpWVhm9vimDA06y1BOvpoU6KZYz5MPAoWAts=";
  };

  nativeBuildInputs = [
    gettext
    python3Packages.pyqt5
    python3Packages.setuptools
    python3Packages.sphinx
    qt5.wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  propagatedBuildInputs = with python3Packages; [
    distro
    mutagen
    polib
    pyqt5
    pyqt5-sip
    semantic-version
    send2trash
    xxhash
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "NO_VENV=1"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # Avoid double wrapping Python programs.
  dontWrapQtApps = true;

  installTargets = "install installdocs";

  # TODO: A bug in python wrapper
  # see https://github.com/NixOS/nixpkgs/pull/75054#discussion_r357656916
  preFixup = ''
    makeWrapperArgs="''${qtWrapperArgs[@]}"
  '';

  # Executable in $out/bin is a symlink to $out/share/dupeguru/run.py
  # so wrapPythonPrograms hook does not handle it automatically.
  postFixup = ''
    wrapPythonProgramsIn "$out/share/dupeguru" "$out ''${pythonPath[*]}"
  '';

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "GUI tool to find duplicate files in a system";
    homepage = "https://github.com/arsenetar/dupeguru";
    changelog = "https://github.com/arsenetar/dupeguru/releases/tag/${builtins.head (lib.strings.splitString "-" finalAttrs.version)}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ novoxd ];
    mainProgram = "dupeguru";
  };
})
