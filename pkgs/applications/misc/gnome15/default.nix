{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python2, gnome_python, gnome_python_desktop }:

stdenv.mkDerivation {
  name = "gnome15-2016-06-10";

  src = fetchFromGitHub {
    owner = "achilleas-k";
    repo = "gnome15";
    rev = "1077c890d9ba8ef7a5e448e70a792de5c7443c84";
    sha256 = "0z5k2rgvv5zyi3lbbk6svncypidj44qzfchivb4vlr7clmh16m95";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python2.pkgs.wrapPython ];
  buildInputs = [ python2 ];
  propagatedBuildInputs = with python2.pkgs; [
    pygtk keyring virtkey pillow dbus-python pyinotify lxml pyxdg pyusb gnome_python gnome_python_desktop
    python-uinput xlib pyudev pyinputevent
  ];

  postPatch = ''
    touch README
    export UDEV_RULES_PATH="$out/lib/udev/rules.d"
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "A set of tools for configuring the Logitech G15 keyboard";
    # Doesn't work with new `keyring` library which is Python 3-only now.
    # https://github.com/Gnome15/gnome15/issues/29
    broken = true;
    license = licenses.gpl3;
    homepage = https://gnome15.org/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
