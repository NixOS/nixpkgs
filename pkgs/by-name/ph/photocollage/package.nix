{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
  gdk-pixbuf,
  gobject-introspection,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "photocollage";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adrienverge";
    repo = "PhotoCollage";
    rev = "v${version}";
    hash = "sha256-YEkQ5yVFCBBFg8IL5ExvZIi0moaG/c0LtsIkphuzuog=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pillow
    pycairo
    pygobject3
  ];

  buildInputs = [
    gdk-pixbuf
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    # Based on the debian package's list of files. Link:
    # https://packages.debian.org/bookworm/all/photocollage/filelist
    install -Dm0644 ./data/photocollage.desktop $out/share/applications/photocollage.desktop
    install -Dm0644 ./data/photocollage.appdata.xml $out/share/appdata/photocollage.appdata.xml
    cp -r ./data/icons $out/share/icons
  '';

  pythonImportsCheck = [ "photocollage" ];

  meta = {
    description = "Graphical tool to make photo collage posters";
    homepage = "https://github.com/adrienverge/PhotoCollage";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "photocollage";
  };
}
