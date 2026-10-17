{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
  qt5,
  gpsd,
  usbutils,
  wirelesstools,
  iw,
  bluez,
  ubertooth,
  aircrack-ng,
  john,
  imagemagick,
  makeDesktopItem,
  writeShellScript,
  copyDesktopItems,
}:
let
  sparrow-wifi-desktop = makeDesktopItem {
    name = "sparrow-wifi";
    desktopName = "Sparrow WiFi";
    exec = "sparrow-wifi-pkexec";
    comment = meta.description;
    icon = "sparrow_wifi_icon";
    categories = [ "Network" ];
    type = "Application";
    terminal = false;
  };

  sparrow-wifi-pkexec = writeShellScript "sparrow-wifi-pkexec" ''
    # pkexec wrapper that passes required variables for X11 and Wayland
    #
    # org.freedesktop.policykit.exec.allow_gui only passes variables for X11
    # so it doesnt work for Wayland

    pkexec env \
      DISPLAY=$DISPLAY \
      XAUTHORITY=$XAUTHORITY \
      WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
      XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
      XDG_SESSION_TYPE=$XDG_SESSION_TYPE \
      QT_QPA_PLATFORM=$QT_QPA_PLATFORM \
      @out@/bin/sparrow-wifi "$@"
  '';

  meta = {
    homepage = "https://github.com/ghostop14/sparrow-wifi";
    description = "Next-Gen GUI-based WiFi and Bluetooth Analyzer for Linux";
    mainProgram = "sparrow-wifi";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ dsuetin ];
    platforms = lib.platforms.linux;
  };
in
python3.pkgs.buildPythonApplication {
  pname = "sparrow-wifi";
  version = "0-unstable-2024-07-25";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ghostop14";
    repo = "sparrow-wifi";
    rev = "b6018c5dfead5294cc2f810d34347a5b5f55aeb0";
    sha256 = "sha256-0CWk6YQgbnwF5NWJsZEpHGlZ6DdH/lcGamBxHg2pa+Y=";
  };

  buildInputs = [
    qt5.qtwayland
  ];

  propagatedBuildInputs = [
    usbutils
    gpsd
    wirelesstools
    bluez
    aircrack-ng
    john
    iw
    ubertooth
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    imagemagick
    copyDesktopItems
  ];

  dependencies = with python3.pkgs; [
    gps3
    python-dateutil
    requests
    pyqt5
    pyqtchart
    numpy
    matplotlib
    manuf
    elasticsearch
    elastic-transport
    pytz
  ];

  patches = [
    # Fix regex warnings
    (fetchpatch {
      url = "https://gitlab.com/kalilinux/packages/sparrow-wifi/-/raw/9b14d8f60c1de62a351edb4071ca9430db60ff6d/debian/patches/Fix-Python-3.12-Syntax-Warnings-use-raw-strings.patch";
      sha256 = "sha256-53TaYP5UCmsQG/nXiFfgD8ebeqrlZik/EDvxub75Lf8=";
    })
  ];

  postPatch = ''
    substituteInPlace sparrow-wifi.py \
      --replace-fail "/usr/bin/xgps" "${lib.getExe' gpsd "xgps"}"

    substituteInPlace sparrowbluetooth.py \
      --replace-fail "/usr/bin/ubertooth-specan" "${lib.getExe' ubertooth "ubertooth-specan"}"

    substituteInPlace sparrowgps.py \
      --replace-fail "/usr/sbin/gpsd" "${lib.getExe' gpsd "gpsd"}"

    substituteInPlace plugins/falconwifi.py \
      --replace-fail "/usr/sbin/airodump-ng" "${lib.getExe' aircrack-ng "airodump-ng"}" \
      --replace-fail "/usr/bin/aircrack-ng" "${lib.getExe' aircrack-ng "aircrack-ng"}" \
      --replace-fail "/usr/bin/wpapcap2john" "${lib.getExe' john "wpapcap2john"}"

    substituteInPlace plugins/falconwifidialogs.py \
      --replace-fail "/usr/sbin/airodump-ng" "${lib.getExe' aircrack-ng "airodump-ng"}" \
      --replace-fail "/usr/bin/aircrack-ng" "${lib.getExe' aircrack-ng "aircrack-ng"}" \
      --replace-fail "/usr/bin/wpapcap2john" "${lib.getExe' john "wpapcap2john"}"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/sparrow-wifi/
    cp -r . $out/lib/sparrow-wifi/

    # Generate and install icon file
    mkdir -p $out/share/icons/hicolor/128x128/apps
    magick wifi_icon.png \
      -background white -gravity center -extent 128x128 \
      $out/share/icons/hicolor/128x128/apps/sparrow_wifi_icon.png

    runHook postInstall
  '';

  dontWrapQtApps = true;

  postFixup = ''
    makeWrapperArgs+=(
      --chdir "$out/lib/sparrow-wifi/"
      --prefix PATH ':' "$program_PATH"
      --prefix PYTHONPATH ':' "$program_PYTHONPATH"
      "''${qtWrapperArgs[@]}"
    )

    mkdir $out/bin

    makeWrapper ${python3.interpreter} $out/bin/sparrow-wifi \
      --add-flags "-O $out/lib/sparrow-wifi/sparrow-wifi.py" \
      ''${makeWrapperArgs[@]}

    makeWrapper ${python3.interpreter} $out/bin/sparrowwifiagent \
      --add-flags "-O $out/lib/sparrow-wifi/sparrowwifiagent.py" \
      ''${makeWrapperArgs[@]}

    makeWrapper ${python3.interpreter} $out/bin/sparrow-elastic \
      --add-flags "-O $out/lib/sparrow-wifi/sparrow-elastic.py" \
      ''${makeWrapperArgs[@]}

    # add pkexec wrapper for desktop file
    substituteAll ${sparrow-wifi-pkexec} $out/bin/sparrow-wifi-pkexec
    chmod +x $out/bin/sparrow-wifi-pkexec
  '';

  desktopItems = [ sparrow-wifi-desktop ];

  inherit meta;
}
