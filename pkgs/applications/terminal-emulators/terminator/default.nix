{ stdenv
, fetchFromGitHub
, python3
, keybinder3
, intltool
, file
, gtk3
, gobject-introspection
, libnotify
, wrapGAppsHook
, vte
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terminator";
  version = "1.92";

  src = fetchFromGitHub {
    owner = "gnome-terminator";
    repo = "terminator";
    rev = "v${version}";
    sha256 = "105f660wzf9cpn24xzwaaa09igg5h3qhchafv190v5nqck6g1ssh";
  };

  nativeBuildInputs = [
    file
    intltool
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
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
    patchShebangs run_tests tests po
    # dbus-python is correctly passed in propagatedBuildInputs, but for some reason setup.py complains.
    # The wrapped terminator has the correct path added, so ignore this.
    substituteInPlace setup.py --replace "'dbus-python'," ""
  '';

  checkPhase = ''
    runHook preCheck

    ./run_tests

    runHook postCheck
  '';

  passthru.tests.test = nixosTests.terminal-emulators.terminator;

  meta = with stdenv.lib; {
    description = "Terminal emulator with support for tiling and tabs";
    longDescription = ''
      The goal of this project is to produce a useful tool for arranging
      terminals. It is inspired by programs such as gnome-multi-term,
      quadkonsole, etc. in that the main focus is arranging terminals in grids
      (tabs is the most common default method, which Terminator also supports).
    '';
    homepage = "https://github.com/gnome-terminator/terminator";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
