{
  lib,
  python3,
  fetchPypi,
  alsa-utils,
  gobject-introspection,
  libnotify,
  wlrctl,
  gtk3,
  safeeyes,
  testers,
  xprintidle,
  xprop,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "safeeyes";
  version = "2.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VE+pcCSblj5CADJppyM1mUchOibUtr7NrVwINrSprY0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail "root_dir = sys.prefix" "root_dir = '/'"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libnotify
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    babel
    psutil
    xlib
    pygobject3
    dbus-python
    croniter
    packaging
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  postInstall = ''
    mv $out/lib/python*/site-packages/share $out/share
  '';

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

  passthru.tests.version = testers.testVersion { package = safeeyes; };

  meta = {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ srghma ];
    platforms = lib.platforms.linux;
    mainProgram = "safeeyes";
  };
}
