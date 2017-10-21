{ stdenv, fetchurl, python27Packages, wmctrl }:

python27Packages.buildPythonPackage rec {
  name = "plover-${version}";
  version = "3.1.0";

  meta = with stdenv.lib; {
    description = "OpenSteno Plover stenography software";
    maintainers = with maintainers; [ twey kovirobi ];
    license = licenses.gpl2;
  };

  src = fetchurl {
    url = "https://github.com/openstenoproject/plover/archive/v${version}.tar.gz";
    sha256 = "1zdlgyjp93sfvk6by7rsh9hj4ijzplglrxpcpkcir6c3nq2bixl4";
  };

  # This is a fix for https://github.com/pypa/pip/issues/3624 causing regression https://github.com/pypa/pip/issues/3781
  postPatch = ''
    substituteInPlace setup.py --replace " in sys_platform" " == sys_platform"
    '';

  buildInputs = with python27Packages; [ pytest mock ];
  propagatedBuildInputs = with python27Packages; [ six setuptools pyserial appdirs hidapi
    wxPython xlib wmctrl ];
}
