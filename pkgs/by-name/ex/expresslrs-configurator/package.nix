{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  asar,
  git,
}:

let
  pname = "expresslrs-configurator";
  version = "1.7.11";
  installPath = "share/${pname}";
  resourcesPath = "${installPath}/resources";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/ExpressLRS/ExpressLRS-Configurator/releases/download/v${version}/${pname}-${version}.zip";
    stripRoot = false;
    hash = "sha256-BIbJzNWjYFbbwCEWoym3g6XBpQGi2owbf2XsQiXwHmw=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    asar
  ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "ExpressLRS Configurator";
      comment = "Configuration tool for ExpressLRS";
      categories = [
        "Utility"
        "Development"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${installPath} $out/bin $out/share/icons/hicolor/512x512/apps
    cp -r $src/locales $src/resources $out/${installPath}/
    chmod -R u+w $out/${resourcesPath}

    # broken symlink
    rm -f $out/${resourcesPath}/app.asar.unpacked/node_modules/@serialport/bindings-cpp/build/node_gyp_bins/python3
    touch $out/${resourcesPath}/app.asar.unpacked/node_modules/@serialport/bindings-cpp/build/node_gyp_bins/python3

    # patch asar absolute paths
    asar extract $out/${resourcesPath}/app.asar $TMPDIR/app
    substituteInPlace $TMPDIR/app/dist/main/main.js \
      --replace-fail 'process.resourcesPath' "'$out/${resourcesPath}'" \
      --replace-fail '__dirname,"../../devices"' "'$out/${resourcesPath}/devices'" \
      --replace-fail '__dirname,"../../assets"' "'$out/${resourcesPath}/assets'" \
      --replace-fail '__dirname,"../../dependencies"' "'$out/${resourcesPath}/dependencies'" \
      --replace-fail '__dirname,"../","i18n","locales"' "'$out/${resourcesPath}/i18n/locales'" \
      --replace-fail '__dirname,"../../.erb/dll/preload.js"' '__dirname,"preload.js"'
    asar pack $TMPDIR/app $out/${resourcesPath}/app.asar

    makeWrapper '${lib.getExe electron}' "$out/bin/${pname}" \
      --add-flags "$out/${resourcesPath}/app.asar" \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
      --set ELECTRON_OVERRIDE_DIST_PATH "${electron}/lib/electron" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform build & configuration tool for ExpressLRS";
    homepage = "https://github.com/ExpressLRS/ExpressLRS-Configurator";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asamonik ];
    mainProgram = "expresslrs-configurator";
  };
}
