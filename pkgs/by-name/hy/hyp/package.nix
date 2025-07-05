{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "hyp-server";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
  };

  meta = with lib; {
    description = "Hyperminimal https server";
    mainProgram = "hyp";
    homepage = "https://github.com/rnhmjoj/hyp";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
