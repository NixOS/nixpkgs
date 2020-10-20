{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "nextinspace";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wrvdwpxwf9aq4mq377mmdlhbgy2ngzf58frp71jdbsipkhb2kcf";
  };

  pythonPath = with python3Packages; [
    requests
    tzlocal
    colorama
  ];

  vendorSha256 = "0z3r8fvpy36ybgb18sr0lril1sg8z7s99xv1a6g1v3zdnj3zimav";

  meta = with lib; {
    description = "Print upcoming space-related events in your terminal";
    homepage = "https://github.com/The-Kid-Gid/nextinspace";
    license = licenses.gpl3;
    maintainers = with maintainers; [ penguwin ];
  };
}
