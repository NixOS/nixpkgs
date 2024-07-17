{
  lib,
  python3Packages,
  fetchFromGitHub,
  glib,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    rev = "refs/tags/printrun-${version}";
    hash = "sha256-MANgxE3z8xq8ScxdxhwfEVsLMF9lgcdSjJZ0qu5p3ps=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "pyglet >= 1.1, < 2.0" "pyglet" \
      --replace "cairosvg >= 1.0.9, < 2.6.0" "cairosvg"
    sed -i -r "s|/usr(/local)?/share/|$out/share/|g" printrun/utils.py
  '';

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
