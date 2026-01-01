{
  lib,
<<<<<<< HEAD
  python3Packages,
=======
  python3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchPypi,
  alsa-utils,
  gobject-introspection,
  libnotify,
  wlrctl,
<<<<<<< HEAD
  gtk4,
  gettext,
=======
  gtk3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  safeeyes,
  testers,
  xprintidle,
  xprop,
  wrapGAppsHook3,
<<<<<<< HEAD
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "safeeyes";
  version = "3.2.0";
=======
}:

python3.pkgs.buildPythonApplication rec {
  pname = "safeeyes";
  version = "2.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-t8PMQxQjfyW3t0bamo8kAlminAMfUe0ThtzrgUc33Xo=";
  };

=======
    hash = "sha256-VE+pcCSblj5CADJppyM1mUchOibUtr7NrVwINrSprY0=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail "root_dir = sys.prefix" "root_dir = '/'"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
<<<<<<< HEAD
    gtk4
    gettext
    libnotify
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
=======
    gtk3
    libnotify
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    babel
    psutil
    xlib
    pygobject3
    dbus-python
<<<<<<< HEAD
    packaging
  ];

  optional-dependencies = with python3Packages; {
    healthstats = [ croniter ];
    wayland = [ pywayland ];
  };

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

=======
    croniter
    packaging
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  postInstall = ''
    mv $out/lib/python*/site-packages/share $out/share
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  passthru.tests.version = testers.testVersion { package = safeeyes; };

  meta = with lib; {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = licenses.gpl3;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "safeeyes";
  };
}
