{ stdenv, fetchFromGitHub, pythonPackages, gnome2, keybinder }:

pythonPackages.buildPythonApplication rec {
  ver = "0.93";
  name = "dockbarx-${ver}";

  src = fetchFromGitHub {
    owner = "M7S";
    repo = "dockbarx";
    rev = ver;
    sha256 = "1h1g2vag5vnx87sa1f0qi8rq7wlr2ymvkrdr08kk7cma4wk0x6hg";
  };

  postPatch = ''
    substituteInPlace setup.py                                --replace /usr/                   ""
    substituteInPlace setup.py                                --replace '"/", "usr", "share",'  '"share",'
    substituteInPlace dockbarx/applets.py                     --replace /usr/share/             $out/share/
    substituteInPlace dockbarx/dockbar.py                     --replace /usr/share/             $out/share/
    substituteInPlace dockbarx/iconfactory.py                 --replace /usr/share/             $out/share/
    substituteInPlace dockbarx/theme.py                       --replace /usr/share/             $out/share/
    substituteInPlace dockx_applets/battery_status.py         --replace /usr/share/             $out/share/
    substituteInPlace dockx_applets/namebar.py                --replace /usr/share/             $out/share/
    substituteInPlace dockx_applets/namebar_window_buttons.py --replace /usr/share/             $out/share/
    substituteInPlace dockx_applets/volume-control.py         --replace /usr/share/             $out/share/
  '';

  propagatedBuildInputs = (with pythonPackages; [ pygtk pyxdg dbus-python pillow xlib ])
    ++ (with gnome2; [ gnome_python gnome_python_desktop ])
    ++ [ keybinder ];

  meta = with stdenv.lib; {
    homepage = "https://launchpad.net/dockbar/";
    description = "DockBarX is a lightweight taskbar / panel replacement for Linux which works as a stand-alone dock";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.volth ];
  };
}
