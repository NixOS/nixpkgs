{ stdenv, fetchurl, python27Packages, python36Packages, wmctrl }:

{
  stable = with python27Packages; buildPythonPackage rec {
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

  dev = with python36Packages; buildPythonPackage rec {
    name    = "plover-${version}";
    version = "4.0.0.dev8";

    meta = with stdenv.lib; {
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [ twey kovirobi ];
      license     = licenses.gpl2;
    };

    src = fetchurl {
      url    = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
      sha256 = "1wxkmik1zyw5gqig5r0cas5v6f5408fbnximzw610rdisqy09rxp";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    checkInputs           = [ pytest mock ];
    propagatedBuildInputs = [ Babel pyqt5 xlib pyserial appdirs wcwidth ];
  };
}
