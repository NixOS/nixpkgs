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

python3Packages.buildPythonApplication rec {
  pname = "hamster";
  version = "3.0.3";

  format = "other";

  src = fetchFromGitHub {
    owner = "projecthamster";
    repo = pname;
    rev = "refs/tags/v${version}";
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
    dbus-python
  ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn $out/libexec "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Time tracking application";
    mainProgram = "hamster";
    homepage = "http://projecthamster.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.fabianhauser ];
  };
}
