{ stdenv, pythonPackages, mopidy, gst_all_1, glib-networking, gobjectIntrospection }:

pythonPackages.buildPythonApplication rec {
  pname = "Mopidy-MPRIS";
  version = "1.4.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0y90k3yzv8lq5g3lxfh4fys7bsmdvqgnwx2kjr00w5j3zrhmfcpa";
  };

  buildInputs = with gst_all_1; [
    gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
    glib-networking gobjectIntrospection
  ];

  propagatedBuildInputs = with pythonPackages; [ mopidy ];

  checkInputs = with pythonPackages; [ pytest mock gst-python pygobject3 pykka tornado requests ];
  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Mopidy extension for controlling Mopidy via dbus";
    license = licenses.asl20;
    maintainers = [ maintainers.thorerik ];
  };
}
