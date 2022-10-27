{ lib
, buildPythonApplication
, fetchPypi
, alsa-utils
, gobject-introspection
, libappindicator-gtk3
, libnotify
, wlrctl
, gtk3
, xprintidle
, xprop
, wrapGAppsHook
, babel
, psutil
, xlib
, pygobject3
, dbus-python
, croniter
}:

buildPythonApplication rec {
  pname = "safeeyes";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b5w887hivmdrkm1ydbar4nmnks6grpbbpvxgf9j9s46msj03c9x";
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
    cp safeeyes/platform/safeeyes.desktop $out/share/applications/safeeyes.desktop
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ alsa-utils wlrctl xprintidle xprop ]}
    )
  '';

  doCheck = false; # no tests

  meta = with lib; {
    homepage = "http://slgobinath.github.io/SafeEyes";
    description = "Protect your eyes from eye strain using this simple and beautiful, yet extensible break reminder. A Free and Open Source Linux alternative to EyeLeo";
    license = licenses.gpl3;
    maintainers = with maintainers; [ srghma ];
    platforms = platforms.linux;
  };
}
