{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, alsa-utils
, gobject-introspection
, libappindicator-gtk3
, libnotify
, wlrctl
, gtk3
<<<<<<< HEAD
, safeeyes
, testers
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, xprintidle
, xprop
, wrapGAppsHook
}:

with python3.pkgs;

buildPythonApplication rec {
  pname = "safeeyes";
<<<<<<< HEAD
  version = "2.1.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tvsBTf6+zKBzB5aL+LUcEvE4jmVHnnoY0L4xoKMJ0vM=";
=======
  version = "2.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IjFDhkqtMitdcQORerRqwty3ZMP8jamPtb9oMHdre4I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
    libnotify
  ];

  propagatedBuildInputs = [
    babel
    psutil
    xlib
    pygobject3
    dbus-python
    croniter
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  postInstall = ''
    mkdir -p $out/share/applications
    cp -r safeeyes/platform/icons $out/share/icons/
<<<<<<< HEAD
    cp safeeyes/platform/io.github.slgobinath.SafeEyes.desktop $out/share/applications/io.github.slgobinath.SafeEyes.desktop
=======
    cp safeeyes/platform/safeeyes.desktop $out/share/applications/safeeyes.desktop
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ alsa-utils wlrctl xprintidle xprop ]}
    )
  '';

  doCheck = false; # no tests

<<<<<<< HEAD
  passthru.tests.version = testers.testVersion { package = safeeyes; };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ srghma ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "safeeyes";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
