{
  lib,
  fetchFromGitHub,
  python3Packages,
  intltool,
  glib,
  itstool,
  gtk3,
  wrapGAppsHook3,
  gobject-introspection,
  pango,
  gdk-pixbuf,
  atk,
  wafHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hamster";
  version = "3.0.3";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "projecthamster";
    repo = "hamster";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-cUmUvJP9Y3de5OaNgIxvigDsX2ww7NNRY5son/gg+WI=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    wrapGAppsHook3
    intltool
    itstool
    wafHook
    glib
    gobject-introspection
  ];

  buildInputs = [
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pycairo
    pyxdg
    setuptools
    dbus-python
  ];

  env.PYTHONDIR = "${placeholder "out"}/${python3Packages.python.sitePackages}";

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/libexec "$out ''${pythonPath[*]}"
  '';

  meta = {
    description = "Time tracking application";
    mainProgram = "hamster";
    homepage = "http://projecthamster.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.fabianhauser ];
  };
})
