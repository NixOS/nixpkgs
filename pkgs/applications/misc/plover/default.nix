{ stdenv, fetchurl, python27Packages, wmctrl }:

with python27Packages; buildPythonPackage rec {
  name    = "plover-${version}";
  version = "3.1.1";

  meta = with stdenv.lib; {
    description = "OpenSteno Plover stenography software";
    maintainers = with maintainers; [ twey kovirobi ];
    license     = licenses.gpl2;
  };

  src = fetchurl {
    url    = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
    sha256 = "1hdg5491phx6svrxxsxp8v6n4b25y7y4wxw7x3bxlbyhaskgj53r";
  };

  buildInputs           = [ pytest mock ];
  propagatedBuildInputs = [
    six setuptools pyserial appdirs hidapi wxPython xlib wmctrl
  ];
};
