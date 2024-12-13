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

with python3.pkgs;

buildPythonApplication rec {
  pname = "safeeyes";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k/CNxLScZDCXiwJhP5qh5HD5VUKlOLaYV8ICYgz6NKI=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "root_dir = sys.prefix" "root_dir = '/'"
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libnotify
  ];

  propagatedBuildInputs = [
    babel
    psutil
    xlib
    pygobject3
    dbus-python
    croniter
    setuptools
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

  passthru.tests.version = testers.testVersion { package = safeeyes; };

  meta = with lib; {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ srghma ];
    platforms = platforms.linux;
    mainProgram = "safeeyes";
  };
}
