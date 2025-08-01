{
  lib,
  python3Packages,
  fetchFromGitHub,
  glib,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    tag = "printrun-${version}";
    hash = "sha256-INJNGAmghoPIiivQp6AV1XmhyIu8SjfKqL8PTpi/tkY=";
  };

  postPatch = ''
    sed -i -r "s|/usr(/local)?/share/|$out/share/|g" printrun/utils.py
  '';

  pythonRelaxDeps = [
    "pyglet"
    "cairosvg"
  ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
    cython
    dbus-python
    numpy
    six
    wxpython
    psutil
    pyglet
    pyopengl
    pyserial
    cffi
    cairosvg
    lxml
    puremagic
  ];

  # pyglet.canvas.xlib.NoSuchDisplayException: Cannot connect to "None"
  doCheck = false;

  setupPyBuildFlags = [ "-i" ];

  postInstall = ''
    for f in $out/share/applications/*.desktop; do
      sed -i -e "s|/usr/|$out/|g" "$f"
    done
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Pronterface, Pronsole, and Printcore - Pure Python 3d printing host software";
    homepage = "https://github.com/kliment/Printrun";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
