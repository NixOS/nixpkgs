{ lib
, python3
, fetchPypi
, wrapGAppsHook
, gtk3
, librsvg
, xorg
, argyllcms
}:

python3.pkgs.buildPythonApplication rec {
  pname = "displaycal";
  version = "3.9.11";
  format = "setuptools";

  src = fetchPypi {
    pname = "DisplayCAL";
    inherit version;
    hash = "sha256-zAZW2eMjwRYevlz8KEzTxzGO8vx5AydfY3vGTapNo1c=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    build
    certifi
    wxpython
    dbus-python
    distro
    numpy
    pillow
    pychromecast
    send2trash
    zeroconf
  ];

  buildInputs = [
    gtk3
    librsvg
  ] ++ (with xorg; [
    libX11
    libXxf86vm
    libXext
    libXinerama
    libXrandr
  ]);

  # Workaround for eoyilmaz/displaycal-py3#261
  setupPyGlobalFlags = [ "appdata" ];

  doCheck = false; # Tests try to access an X11 session and dbus in weird locations.

  pythonImportsCheck = [ "DisplayCAL" ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      ''${gappsWrapperArgs[@]}
      --prefix PATH : ${lib.makeBinPath [ argyllcms ]}
      --prefix PYTHONPATH : $PYTHONPATH
    )
  '';

  meta = with lib; {
    description = "Display calibration and characterization powered by Argyll CMS (Migrated to Python 3)";
    homepage = "https://github.com/eoyilmaz/displaycal-py3";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ toastal ];
  };
}
