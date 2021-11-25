{ lib
, fetchFromGitHub
, glib
, gobject-introspection
, gtk3
, keybinder3
, libwnck
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "dockbarx";
  version = "${ver}-${rev}";
  ver = "1.0-beta";
  rev = "d98020ec49f3e3a5692ab2adbb145bbe5a1e80fe";

  src = fetchFromGitHub {
    owner = "xuzhen";
    repo = "dockbarx";
    rev = rev;
    sha256 = "0xwqxh5mr2bi0sk54b848705awp0lfpd91am551811j2bdkbs04m";
  };

  nativeBuildInputs = [
    glib.dev
    python3Packages.polib
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    gtk3
    libwnck
    keybinder3
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pillow
    pygobject3
    pyxdg
    xlib
  ];

  # no tests
  doCheck = false;

  dontWrapGApps = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace /usr/ "" \
      --replace '"/", "usr", "share",' '"share",'

    for f in \
      dbx_preference \
      dockbarx/applets.py \
      dockbarx/dockbar.py \
      dockbarx/iconfactory.py \
      dockbarx/theme.py \
      mate_panel_applet/dockbarx_mate_applet
    do
      substituteInPlace $f --replace /usr/share/ $out/share/
    done
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/xuzhen/dockbarx";
    description = "Lightweight taskbar/panel replacement which works as a stand-alone dock";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
