{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  glib,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "printrun";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kliment";
    repo = "Printrun";
    tag = "printrun-${version}";
    hash = "sha256-INJNGAmghoPIiivQp6AV1XmhyIu8SjfKqL8PTpi/tkY=";
  };

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [
    setuptools
    cython
  ];

  dependencies =
    with python3Packages;
    [
      pyserial
      wxpython
      numpy
      pyglet
      psutil
      lxml
      platformdirs
      puremagic
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux dbus-python
    ++ lib.optional stdenv.hostPlatform.isDarwin pyobjc-framework-Cocoa;

  pythonRelaxDeps = [ "pyglet" ];

  # pyglet.canvas.xlib.NoSuchDisplayException: Cannot connect to "None"
  doCheck = false;

  postInstall = ''
    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail /usr/bin/ ""
    substituteInPlace $out/share/applications/pronterface.desktop \
      --replace-fail "Path=/usr/share/pronterface/" ""
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Pronterface, Pronsole, and Printcore - Pure Python 3d printing host software";
    homepage = "https://github.com/kliment/Printrun";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/kliment/Printrun/releases/tag/${src.tag}";
  };
}
