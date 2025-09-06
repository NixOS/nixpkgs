{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  unzip,
  makeWrapper,
  desktop-file-utils,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libdrm,
  libxkbcommon,
  libxshmfence,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  wayland,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "edhm-ui";
  version = "3.0.45";

  src = fetchurl {
    url = "https://github.com/BlueMystical/EDHM_UI/releases/download/v${version}/edhm-ui-v3-linux-x64.zip";
    sha256 = "0yq0q8cb5gkyp76738n1k7dl4zhvzdqvglap4qavf1s97zkpinya";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
    makeWrapper
    desktop-file-utils
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libxkbcommon
    libxshmfence
    mesa
    nspr
    nss
    pango
    systemd
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxshmfence
  ];

  sourceRoot = ".";

  installPhase = ''
        runHook preInstall

        mkdir -p $out/opt/edhm-ui
        cp -r edhm-ui-v3-linux-x64/* $out/opt/edhm-ui/

        # Make the main executable... executable
        chmod +x $out/opt/edhm-ui/edhm-ui-v3

        # Create wrapper script
        makeWrapper $out/opt/edhm-ui/edhm-ui-v3 $out/bin/edhm-ui \
          --set LD_LIBRARY_PATH "${lib.makeLibraryPath buildInputs}" \
          --prefix PATH : ${lib.makeBinPath [ ]}

        # Install desktop entry
        mkdir -p $out/share/applications
        cat > $out/share/applications/edhm-ui.desktop <<EOF
    [Desktop Entry]
    Name=EDHM UI
    Comment=Elite Dangerous HUD Mod Manager
    Exec=$out/bin/edhm-ui
    Icon=$out/opt/edhm-ui/resources/images/icon.png
    Terminal=false
    Type=Application
    Categories=Game;Utility;
    StartupWMClass=edhm-ui-v3
    EOF

        # Install icon
        mkdir -p $out/share/pixmaps
        cp $out/opt/edhm-ui/resources/images/icon.png $out/share/pixmaps/edhm-ui.png

        # Validate desktop entry
        desktop-file-validate $out/share/applications/edhm-ui.desktop

        runHook postInstall
  '';

  meta = {
    description = "Elite Dangerous HUD Mod Manager - A tool for managing HUD modifications in Elite Dangerous";
    homepage = "https://github.com/BlueMystical/EDHM_UI";
    license = [
      lib.licenses.gpl3Only # EDHM UI itself is GPL v3
      lib.licenses.unfree # EDHM core has custom restrictive license with all rights reserved
    ];
    maintainers = [ lib.maintainers.michael-k-williams ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "edhm-ui";
    longDescription = ''
      EDHM UI is a GPL v3 licensed user interface for managing Elite Dangerous HUD modifications.
      It includes EDHM (Elite Dangerous HUD Mod) which has a custom restrictive license.

      Note: The underlying EDHM tool has a custom license with significant restrictions:
      - Personal and non-commercial use only
      - No modification, redistribution, or reuse without explicit permission
      - All rights reserved by original authors (Fred89210 and psychicEgg)

      This is a fan-made modification for Elite Dangerous and is not affiliated with
      Frontier Developments plc.
    '';
  };
}
