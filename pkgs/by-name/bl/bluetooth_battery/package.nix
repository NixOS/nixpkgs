{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bluetooth_battery";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "TheWeirdDev";
    repo = "Bluetooth_Headset_Battery_Level";
    rev = "v${finalAttrs.version}";
    hash = "sha256-egChnBdyvpB3+e54daRUAEzSG0JX2lVSD54hIWB3+Bg=";
  };

  propagatedBuildInputs = with python3Packages; [ pybluez ];

  pyproject = false;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bluetooth_battery.py $out/bin/bluetooth_battery
  '';

  meta = {
    description = "Fetch the battery charge level of some Bluetooth headsets";
    mainProgram = "bluetooth_battery";
    homepage = "https://github.com/TheWeirdDev/Bluetooth_Headset_Battery_Level";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cheriimoya ];
  };
})
