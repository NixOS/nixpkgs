{ lib
, python3
, xorg
, argyllcms
, wrapGAppsHook
, gtk3
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "displaycal";
  version = "3.9.10";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    pname = "DisplayCAL";
    inherit version;
    hash = "sha256-oDHDVb0zuAC49yPfmNe7xuFKaA1BRZGr75XwsLqugHs=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    build
    certifi
    wxPython_4_2
    dbus-python
    distro
    pychromecast
    send2trash
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
