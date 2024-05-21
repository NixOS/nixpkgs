{ lib
, fetchFromGitHub
, python3
, keybinder3
, intltool
, file
, gtk3
, gobject-introspection
, libnotify
, makeBinaryWrapper
, wrapGAppsHook3
, vte
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terminator";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "gnome-terminator";
    repo = "terminator";
    rev = "v${version}";
    hash = "sha256-Kx0z9oheA7Ihgsyg6zgPcGFMrqlXoIpQcL/dMqPB2qA=";
  };

  nativeBuildInputs = [
    file
    intltool
    gobject-introspection
    makeBinaryWrapper
    wrapGAppsHook3
    python3.pkgs.pytest-runner
  ];

  buildInputs = [
    gtk3
    keybinder3
    libnotify
    python3
    vte
  ];

  propagatedBuildInputs = with python3.pkgs; [
    configobj
    dbus-python
    pygobject3
    psutil
    pycairo
  ];

  postPatch = ''
    patchShebangs tests po
  '';

  doCheck = false;

  dontWrapGApps = true;

  # HACK: 'wrapPythonPrograms' will add things to the $PATH in the wrapper. This bleeds into the
  # terminal session produced by terminator. To avoid this, we force wrapPythonPrograms to only
  # use gappsWrapperArgs by redefining wrapProgram to ignore its arguments and only apply the
  # wrapper arguments we want it to use.
  # TODO: Adjust wrapPythonPrograms to respect an argument that tells it to leave $PATH alone.
  preFixup = ''
    wrapProgram() {
      wrapProgramBinary "$1" "''${gappsWrapperArgs[@]}"
    }
  '';

  passthru.tests.test = nixosTests.terminal-emulators.terminator;

  meta = with lib; {
    description = "Terminal emulator with support for tiling and tabs";
    longDescription = ''
      The goal of this project is to produce a useful tool for arranging
      terminals. It is inspired by programs such as gnome-multi-term,
      quadkonsole, etc. in that the main focus is arranging terminals in grids
      (tabs is the most common default method, which Terminator also supports).
    '';
    changelog = "https://github.com/gnome-terminator/terminator/releases/tag/v${version}";
    homepage = "https://github.com/gnome-terminator/terminator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
