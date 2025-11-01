{
  lib,
  python3Packages,
  fetchPypi,
  alsa-utils,
  gobject-introspection,
  libnotify,
  wlrctl,
  gtk4,
  gettext,
  safeeyes,
  testers,
  xprintidle,
  xprop,
  wrapGAppsHook3,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "safeeyes";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t8PMQxQjfyW3t0bamo8kAlminAMfUe0ThtzrgUc33Xo=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    gettext
    libnotify
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    babel
    psutil
    xlib
    pygobject3
    dbus-python
    packaging
  ];

  optional-dependencies = with python3Packages; {
    healthstats = [ croniter ];
    wayland = [ pywayland ];
  };

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          alsa-utils
          wlrctl
          xprintidle
          xprop
        ]
      }
    )
  '';

  doCheck = false; # no tests

  pythonImportsCheck = [ "safeeyes" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = safeeyes; };
  };

  meta = {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Free GNU/Linux alternative to EyeLeo";
    longDescription = ''
      Protect your eyes from eye strain using this simple and
      beautiful, yet extensible break reminder.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "safeeyes";
  };
}
