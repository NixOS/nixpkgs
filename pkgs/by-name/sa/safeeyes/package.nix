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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "safeeyes";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-11nw13AAqupSIZRrhmDaViO3V/yYK8/xsVF8ylS49Rw=";
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
    description = "Break reminder to prevent eye strain";
    longDescription = ''
      Protect your eyes from eye strain using this simple and
      beautiful, yet extensible break reminder.  Free GNU/Linux
      alternative to EyeLeo.
    '';
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "safeeyes";
  };
})
