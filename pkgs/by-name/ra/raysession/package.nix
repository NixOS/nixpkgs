{
  lib,
  fetchFromGitHub,
  python3Packages,
  which,
  bash,
  qt6,
  coreutils,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "raysession";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Houston4444";
    repo = "RaySession";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YCQl7PEmkC68WkoOpUX4TrsCAm+jJyONakZp+VSKjts=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Fix installation path of xdg schemas.
    substituteInPlace Makefile --replace-fail '$(DESTDIR)/' '$(DESTDIR)$(PREFIX)/'
    # Fix the python3 invocation in the completions
    substituteInPlace src/completion/ray_completion.sh \
      --replace-fail python3 ${lib.getExe python3Packages.python}

    # Mark importable modules as non-executable as to not binwrap them
    chmod -x src/control/ray_control.py
    chmod -x src/daemon/desktops_memory.py
    chmod -x src/daemon/ray_daemon.py
    chmod -x src/gui/raysession.py
    chmod -x src/patchbay_daemon/patchbay_daemon.py
  '';

  pyproject = false;

  nativeBuildInputs = [
    python3Packages.pyqt6 # pyuic6 and rcc to build resources.
    qt6.qttools # lrelease to build translations.
    which # which to find lrelease
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    bash
    coreutils # Some shebangs use "env -S"
  ];

  dependencies = with python3Packages; [
    pyqt6
    qtpy
    pyliblo3
    jack-client
  ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeFlags = [
    "RCC=${qt6.qtbase}/libexec/rcc"
  ];

  strictDeps = true;

  postFixup = ''
    wrapPythonProgramsIn "$out/share/raysession/src" "$out ''${pythonPath[*]}"
    for file in $out/bin/*; do
      wrapQtApp "$file"
    done
  '';

  meta = {
    homepage = "https://github.com/Houston4444/RaySession";
    description = "Session manager for Linux musical programs";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ vojtechstep ];
    platforms = lib.platforms.linux;
    mainProgram = "raysession";
  };
})
