{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  gtk3,
}:
python3Packages.buildPythonApplication rec {
  pname = "nwg-icon-picker";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-icon-picker";
    tag = "v${version}";
    hash = "sha256-Gm3JhS6eq2mSex4VFe71tRf13qWDCSqXoiMvNIhu9Sw=";
  };

  build-system = with python3Packages; [
    setuptools
    wrapGAppsHook3
    gobject-introspection
  ];

  dependencies = with python3Packages; [
    pygobject3
    gtk3
  ];

  postInstall = ''
    install -Dm444 -t $out/share/pixmaps/ nwg-icon-picker.svg
    install -Dm444 -t $out/share/applications/ nwg-icon-picker.desktop
  '';

  # prevent double wrapped binary
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [
    "gi"
  ];

  meta = {
    description = "GTK icon chooser with a text search option";
    homepage = "https://github.com/nwg-piotr/nwg-icon-picker";
    license = lib.licenses.mit;
    mainProgram = "nwg-icon-picker";
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
