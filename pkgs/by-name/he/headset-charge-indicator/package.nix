{
  lib,
  stdenv,
  fetchFromGitHub,
  headsetcontrol,
  wrapGAppsHook3,
  python3,
  gtk3,
  gobject-introspection,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  # The last versioned release is 1.0.0.0 from 2020, since then there were updates but no versioned release.
  # This is not marked unstable because upstream encourages installation from source.
  pname = "headset-charge-indicator";
  version = "2021-08-15";

  src = fetchFromGitHub {
    owner = "centic9";
    repo = "headset-charge-indicator";
    rev = "6e20f81a4d6118c7385b831044c468af83103193";
    sha256 = "sha256-eaAbqeFY+B3CcKJywC3vaRsWZNQENTbALc7L7uW0W6U=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    (python3.withPackages (ps: with ps; [ pygobject3 ]))
    headsetcontrol
    gtk3
    libayatana-appindicator
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/headset-charge-indicator.py $out/bin/headset-charge-indicator.py
    chmod +x $out/bin/headset-charge-indicator.py

    substituteInPlace \
      $out/bin/headset-charge-indicator.py \
      --replace "default='headsetcontrol'" "default='${headsetcontrol}/bin/headsetcontrol'"

    cat << EOF > ${pname}.desktop
    [Desktop Entry]
    Name=Wireless headset app-indicator
    Categories=Application;System
    Exec=$out/bin/headset-charge-indicator.py
    Terminal=false
    Type=Application
    X-GNOME-AutoRestart=true
    X-GNOME-Autostart-enabled=true
    EOF

    mkdir -p $out/share/applications
    mkdir -p $out/etc/xdg/autostart
    cp ${pname}.desktop $out/share/applications/${pname}.desktop
    cp ${pname}.desktop $out/etc/xdg/autostart/${pname}.desktop
  '';

  meta = with lib; {
    homepage = "https://github.com/centic9/headset-charge-indicator";
    description = "A app-indicator for GNOME desktops for controlling some features of various wireless headsets";
    longDescription = "A simple app-indicator for GNOME desktops to display the battery charge of some wireless headsets which also allows to control some functions like LEDs, sidetone and others.";
    platforms = platforms.linux;
    maintainers = with maintainers; [ zebreus ];
    license = licenses.bsd2;
    mainProgram = "headset-charge-indicator.py";
  };
}
