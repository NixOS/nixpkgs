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
  version = "3.9.19";
  pyproject = true;

  src = fetchPypi {
    pname = "displaycal";
    inherit (finalAttrs) version;
    hash = "sha256-GHx+2VwuxwdMQh6fxY6V/EQJE4CPxer39Aj/QlMWbrw=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gtk3
  ];

  build-system = with python3.pkgs; [ setuptools_80 ];

  postPatch = ''
    # 2 conflicting copies of bin/displaycal end up from the installation
    # process (one from pyproject.toml’s gui-scripts, one from setup.py). Keep
    # only the setup.py version. Replace key with an invalide name to be
    # skipped.
    substituteInPlace pyproject.toml \
      --replace-fail "[project.gui-scripts]" "[_project.gui-scripts]" \
  '';

  dependencies = with python3.pkgs; [
    build
    certifi
    defusedxml
    wxpython
    dbus-python
    distro
    numpy
    pillow
    psutil
    pychromecast
    pyglet
    pyyaml
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
