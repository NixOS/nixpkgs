{ lib, fetchFromGitHub, buildPythonApplication, pybluez }:

buildPythonApplication rec {
  pname = "bluetooth_battery";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "TheWeirdDev";
    repo = "Bluetooth_Headset_Battery_Level";
    rev = "v${version}";
    sha256 = "067qfxh228cy1x95bnjp88dx4k00ajj7ay7fz5vr1gkj2yfa203s";
  };

  propagatedBuildInputs = [ pybluez ];

  format = "other";

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bluetooth_battery.py $out/bin/bluetooth_battery
  '';

  meta = with lib; {
    description = "Fetch the battery charge level of some Bluetooth headsets";
    mainProgram = "bluetooth_battery";
    homepage = "https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cheriimoya ];
  };
}
