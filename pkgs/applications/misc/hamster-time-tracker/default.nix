{ stdenv, fetchzip, pythonPackages, docbook2x, libxslt, gnome-doc-utils
, intltool, dbus-glib, gnome_python
, hicolor-icon-theme
, wafHook
}:

# TODO: Add optional dependency 'wnck', for "workspace tracking" support. Fixes
# this message:
#
#   WARNING:root:Could not import wnck - workspace tracking will be disabled

pythonPackages.buildPythonApplication rec {
  name = "hamster-time-tracker-1.04";

  src = fetchzip {
    name = "${name}-src";
    url = "https://github.com/projecthamster/hamster/archive/${name}.tar.gz";
    sha256 = "1a85rcg561792kdyv744cgzw7mmpmgv6d6li1sijfdpqa1ninf8g";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs = [
    docbook2x libxslt gnome-doc-utils intltool dbus-glib hicolor-icon-theme
  ];

  propagatedBuildInputs = with pythonPackages; [ pygobject2 pygtk pyxdg gnome_python dbus-python ];

  postFixup = ''
    wrapPythonProgramsIn $out/lib/hamster-time-tracker "$out $pythonPath"
  '';

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Time tracking application";
    homepage = https://projecthamster.wordpress.com/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
