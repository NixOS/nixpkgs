{
  autoPatchelfHook,
  copyDesktopItems,
  curl,
  fetchurl,
  gsettings-desktop-schemas,
  gtk3,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenv,
  webkitgtk_4_1,
}:

stdenv.mkDerivation rec {
  pname = "playdate-sdk";
  version = "3.1.0";

  src = fetchurl {
    url = "https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-${version}.tar.gz";
    sha256 = "sha256-yKEl3UpVY3lB9LxAsx0RotTsNHv8WS76ZqpzRi6BSZg=";
  };

  srcScript = ./playdate-simulator-wrapper.sh;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    webkitgtk_4_1
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/playdate-sdk
    cp -r * $out/share/playdate-sdk
    mkdir -p $out/bin

    #### pdc
    makeWrapper $out/share/playdate-sdk/bin/pdc $out/bin/pdc \
      --run 'export PLAYDATE_SDK_PATH="''${XDG_DATA_HOME:-''$HOME/.local/share}/playdate-sdk-${version}"'

    #### pdutil
    makeWrapper $out/share/playdate-sdk/bin/pdutil $out/bin/pdutil \
      --run 'export PLAYDATE_SDK_PATH="''${XDG_DATA_HOME:-''$HOME/.local/share}/playdate-sdk-${version}"'

    #### PlaydateSimulator
    cp $srcScript $out/bin/PlaydateSimulator
    substituteInPlace $out/bin/PlaydateSimulator \
      --subst-var-by out "$out" \
      --subst-var-by version "${version}" \
      --subst-var-by ldLibraryPath "${
        lib.makeLibraryPath [
          curl
        ]
      }" \
      --subst-var-by gsettingsSchemas "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}"
    chmod +x $out/bin/PlaydateSimulator

    #### C API includes
    mkdir -p $out/include
    cp -r $out/share/playdate-sdk/C_API/pd_api $out/include/pd_api
    cp $out/share/playdate-sdk/C_API/pd_api.h $out/include/pd_api.h

    #### udev rules
    mkdir -p $out/etc/udev/rules.d
    cp $out/share/playdate-sdk/Resources/50-playdate.rules $out/etc/udev/rules.d/

    #### icons
    install -Dm644 $out/share/playdate-sdk/Resources/date.play.simulator.svg $out/share/icons/hicolor/scalable/apps/PlaydateSimulator.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "PlaydateSimulator";
      exec = "PlaydateSimulator %u";
      icon = "PlaydateSimulator";
      desktopName = "Playdate Simulator";
      comment = "A toolset for developing games on the Playdate handheld console";
      categories = [ "Development" ];
      startupWMClass = "PlaydateSimulator";
      mimeTypes = [
        "application/x-playdate-game"
        "x-scheme-handler/playdate-simulator"
      ];
    })
  ];

  meta = {
    description = "Official SDK and development tools for the Playdate handheld console, including Lua/C APIs, simulator, and Mirror capture utility";
    homepage = "https://play.date";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ atomicptr ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
