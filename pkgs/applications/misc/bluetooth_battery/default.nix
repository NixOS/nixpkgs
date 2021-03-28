{ lib, fetchFromGitHub, buildPythonApplication, pybluez }:

buildPythonApplication rec {
  pname = "bluetooth_battery";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "TheWeirdDev";
    repo = "Bluetooth_Headset_Battery_Level";
    rev = "v${version}";
    sha256 = "121pkaq9z8p2i35cqs32aygjvf82r961w0axirpmsrbmrwq2hh6g";
  };

  propagatedBuildInputs = [ pybluez ];

  format = "other";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bluetooth_battery.py $out/bin/bluetooth_battery
  '';

  meta = with lib; {
    description = "Fetch the battery charge level of some Bluetooth headsets";
    homepage = "https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cheriimoya ];
  };
}
