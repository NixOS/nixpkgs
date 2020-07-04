{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-mpris";
  version = "3.0.1";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-MPRIS";
    sha256 = "0qk46aq5r92qgkldzl41x09naww1gv92l4c4hknyl7yymyvm9lr2";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.pydbus
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.mopidy.com/;
    description = "Mopidy extension for controlling Mopidy through D-Bus using the MPRIS specification";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}

