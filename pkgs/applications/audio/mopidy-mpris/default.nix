{ stdenv, fetchFromGitHub, pythonPackages, mopidy }:

pythonPackages.buildPythonApplication rec {
  name = "mopidy-mpris-${version}";

  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-mpris";
    rev = "v${version}";
    sha256 = "0a8hd7vcvy2whmb9qamafx787rjnvnkz4z36ncnydi0dirbnc3d1";
  };

  propagatedBuildInputs = with pythonPackages; [ mopidy ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Mopidy extension for controlling Mopidy via dbus";
    license = licenses.asl20;
    maintainers = [ maintainers.thorerik ];
  };
}
