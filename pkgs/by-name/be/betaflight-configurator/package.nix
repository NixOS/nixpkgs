{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  unzip,
  undmg,
  makeDesktopItem,
  nwjs,
  wrapGAppsHook3,
  gsettings-desktop-schemas,
  gtk3,
}:

let
  pname = "betaflight-configurator";
  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    comment = "Betaflight configuration tool";
    desktopName = "Betaflight Configurator";
    genericName = "Flight controller configuration tool";
  };
  platform =
    if stdenv.hostPlatform.isLinux then
      {
        suffix = "linux64-portable.zip";
        hash = "sha256-UB5Vr5wyCUZbOaQNckJQ1tAXwh8VSLNI1IgTiJzxV08=";
        installPhase = ''
          mkdir -p $out/bin \
                   $out/opt/${pname}
          cp -r . $out/opt/${pname}/
          install -m 444 -D icon/bf_icon_128.png $out/share/icons/hicolor/128x128/apps/${pname}.png
          cp -r ${desktopItem}/share/applications $out/share/
          makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags $out/opt/${pname}
        '';
      }
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      {
        suffix = "macOS.dmg";
        hash = "sha256-qd2t0tmD5ihlyrejg59aZRPjyDmgxMPHm1+pcw7Vo70=";
        installPhase =
          let
            appName = "Betaflight\\ Configurator.app";
          in
          ''
            mkdir -p $out/{Applications/${appName},bin}
            cp -R . $out/Applications/${appName}
            cat > $out/bin/${pname} << EOF
            #!${stdenvNoCC.shell}
            open -na $out/Applications/${appName} --args "\$@"
            EOF
            chmod +x $out/bin/${pname}
          '';
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "10.10.0";
  src = fetchurl {
    url = "https://github.com/betaflight/${pname}/releases/download/${version}/${pname}_${version}_${platform.suffix}";
    inherit (platform) hash;
  };

  # remove large unneeded files
  postUnpack = lib.optionalString stdenv.hostPlatform.isLinux ''
    find -name "lib*.so" -delete
  '';

  nativeBuildInputs = [
    unzip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
    undmg
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gsettings-desktop-schemas
    gtk3
  ];

  installPhase = ''
    runHook preInstall
    ${platform.installPhase}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Betaflight flight control system configuration tool";
    mainProgram = "betaflight-configurator";
    longDescription = ''
      A crossplatform configuration tool for the Betaflight flight control system.
      Various types of aircraft are supported by the tool and by Betaflight, e.g.
      quadcopters, hexacopters, octocopters and fixed-wing aircraft.
    '';
    homepage = "https://github.com/betaflight/betaflight/wiki";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
  };
}
