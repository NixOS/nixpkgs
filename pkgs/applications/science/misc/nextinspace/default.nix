{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "nextinspace";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h3dksxyy5gq071fa7i2p73s50918y1bkk38hgfwr4226c3wipvg";
  };

  pythonPath = with python3Packages; [
    requests
    tzlocal
    colorama
  ];

  meta = with lib; {
    description = "Print upcoming space-related events in your terminal";
    homepage = "https://github.com/The-Kid-Gid/nextinspace";
    license = licenses.gpl3;
    maintainers = with maintainers; [ penguwin ];
  };
}
