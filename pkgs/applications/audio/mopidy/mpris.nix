{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-mpris";
  version = "3.0.2";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-MPRIS";
    sha256 = "0mmdaikw00f43gzjdbvlcvzff6yppm7v8mv012r79adzd992q9y0";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.pydbus
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.mopidy.com/";
    description = "Mopidy extension for controlling Mopidy through D-Bus using the MPRIS specification";
    license = licenses.asl20;
    maintainers = [ maintainers.nickhu ];
  };
}

