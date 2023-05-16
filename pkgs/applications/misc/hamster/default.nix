{ lib, fetchFromGitHub, python3Packages, intltool, glib, itstool, gtk3
<<<<<<< HEAD
, wrapGAppsHook, gobject-introspection, pango, gdk-pixbuf, atk, waf }:
=======
, wrapGAppsHook, gobject-introspection, pango, gdk-pixbuf, atk, wafHook }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "hamster";
  version = "3.0.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "projecthamster";
    repo = pname;
    rev = "v${version}";
    sha256 = "09ikiwc2izjvwqbbyp8knn190x5y4anwslkmb9k2h3r3jwrg2vd2";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    wrapGAppsHook
    intltool
    itstool
<<<<<<< HEAD
    waf.hook
=======
    wafHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "http://projecthamster.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.fabianhauser ];
  };
}
