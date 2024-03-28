{ lib
, python3
, fetchFromGitHub
, qt5
, gpsd
, stdenv
, usbutils
, wirelesstools
, iw
, bluez
, ubertooth
, aircrack-ng
, john
, copyDesktopItems
, imagemagick
, makeDesktopItem
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sparrow-wifi";
  version = "unstable-2023-05-16";
  format = "other";

  src = fetchFromGitHub {
    owner = "ghostop14";
    repo = "sparrow-wifi";
    rev = "3154f36913379efff502aeab7aa4a3d3a94b496e";
    sha256 = "sha256-jzCfcnqdX2Znvwv6UPKMNBIfm+4La91RZRPN5UGWkM4=";
  };

  buildInputs = [
    usbutils
    gpsd
    wirelesstools
    bluez
    aircrack-ng
    john
    iw
    ubertooth
  ];

  nativeBuildInputs = [ qt5.wrapQtAppsHook copyDesktopItems imagemagick ];

  propagatedBuildInputs = with python3.pkgs; [
    gps3
    python-dateutil
    requests
    pyqt5
    pyqtchart
    numpy
    matplotlib
    manuf
  ];

  dontBuild = true;

  postPatch = ''
    patchShebangs .

    substituteInPlace sparrow-wifi.py \
      --replace "/usr/bin/xgps" "${gpsd}/bin/xgps"

    substituteInPlace sparrowbluetooth.py \
      --replace "/usr/bin/ubertooth-specan" "${ubertooth}/bin/ubertooth-specan"

    substituteInPlace sparrowgps.py \
      --replace "/usr/sbin/gpsd" "${gpsd}/sbin/gpsd"

    substituteInPlace plugins/falconwifi.py \
      --replace "/usr/sbin/airodump-ng" "${aircrack-ng}/sbin/airodump-ng" \
      --replace "/usr/bin/aircrack-ng" "${aircrack-ng}/bin/aircrack-ng" \
      --replace "/usr/bin/wpapcap2john" "${john}/bin/wpapcap2john"

    substituteInPlace plugins/falconwifidialogs.py \
      --replace "/usr/sbin/airodump-ng" "${aircrack-ng}/sbin/airodump-ng" \
      --replace "/usr/bin/aircrack-ng" "${aircrack-ng}/bin/aircrack-ng" \
      --replace "/usr/bin/wpapcap2john" "${john}/bin/wpapcap2john"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/sparrow-wifi/
    cp -r . $out/lib/sparrow-wifi/
    mkdir $out/bin

    makeWrapper ${python3.interpreter} $out/bin/sparrow-wifi \
      --add-flags "-O $out/lib/sparrow-wifi/sparrow-wifi.py" \
      --prefix PATH : "${lib.makeBinPath [ usbutils gpsd wirelesstools bluez aircrack-ng john iw ]}" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]} \
      --chdir "$out/lib/sparrow-wifi/" \
      ''${makeWrapperArgs[@]} \
      ''${qtWrapperArgs[@]}

    makeWrapper ${python3.interpreter} $out/bin/sparrowwifiagent \
      --add-flags "-O $out/lib/sparrow-wifi/sparrowwifiagent.py" \
      --prefix PATH : "${lib.makeBinPath [ usbutils gpsd wirelesstools bluez aircrack-ng john iw ]}" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --chdir "$out/lib/sparrow-wifi/" \
      ''${makeWrapperArgs[@]} \
      ''${qtWrapperArgs[@]}

    makeWrapper ${python3.interpreter} $out/bin/sparrow-elastic \
      --add-flags "-O $out/lib/sparrow-wifi/sparrow-elastic.py" \
      --prefix PATH : "${lib.makeBinPath [ usbutils gpsd wirelesstools bluez aircrack-ng john iw ]}" \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --chdir "$out/lib/sparrow-wifi/" \
      ''${makeWrapperArgs[@]} \
      ''${qtWrapperArgs[@]}

    runHook postInstall
  '';

  dontWrapQtApps = true;

  doCheck = false;

  postInstall = ''
    # Generate and install icon files
    for size in 16 32 48 64 72 96 128 192 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert wifi_icon.png -sample "$size"x"$size" \
        -background white -gravity south -extent "$size"x"$size" \
        $out/share/icons/hicolor/"$size"x"$size"/apps/wifi_icon.png
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Sparrow WiFi";
      desktopName = "Sparrow WiFi";
      exec = "sparrow-wifi";
      comment = meta.description;
      icon = "wifi_icon";
      categories = [ "Network" ];
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/ghostop14/sparrow-wifi";
    description = "Next-Gen GUI-based WiFi and Bluetooth Analyzer for Linux";
    mainProgram = "sparrow-wifi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dsuetin ];
    platforms = platforms.linux;
  };
}
