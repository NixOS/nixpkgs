{
  lib,
  python3,
  fetchPypi,
  wrapGAppsHook3,
  gtk3,
  librsvg,
  libxxf86vm,
  libxrandr,
  libxinerama,
  libxext,
  libx11,
  argyllcms,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "displaycal";
  version = "3.9.17";
  format = "setuptools";

  src = fetchPypi {
    pname = "DisplayCAL";
    inherit (finalAttrs) version;
    hash = "sha256-cV8x1Hx+KQUhOOzqw/89QgoZ9+82vhwGrhG13KpE9Vw=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
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
    libx11
    libxxf86vm
    libxext
    libxinerama
    libxrandr
  ];

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

  meta = {
    description = "Display calibration and characterization powered by Argyll CMS (Migrated to Python 3)";
    homepage = "https://github.com/eoyilmaz/displaycal-py3";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
