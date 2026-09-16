{
  lib,
  stdenvNoCC,
  appimageTools,
  fetchurl,
  unzip,
}:

let
  pname = "display-pilot-2";
  version = "1.1.4.0";

  appimage = stdenvNoCC.mkDerivation {
    pname = "${pname}-appimage";
    inherit version;

    src = fetchurl {
      url = "https://esupportdownload.benq.com/esupport/VERTICAL%20%26%20PROFESSIONAL%20DISPLAY/Software/Display%20Pilot%202/Display%20Pilot%202_Display%20Pilot%202%20for%20Linux_V${version}_Linux_260407094616.zip";
      hash = "sha256-IWFIR5VpnZiNP11VQLTWmoezfLbcXKrGB7VWgaf/Fxo=";
    };

    nativeBuildInputs = [ unzip ];

    unpackPhase = ''
      runHook preUnpack

      unzip "$src"

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      install -Dm555 "Display Pilot 2-${version}-release.AppImage" "$out"

      runHook postInstall
    '';
  };
in
appimageTools.wrapType2 (finalAttrs: {
  inherit pname version;
  src = appimage;

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/usr/share/applications/com.benq.DisplayPilot2.desktop \
      $out/share/applications/com.benq.DisplayPilot2.desktop
    substituteInPlace $out/share/applications/com.benq.DisplayPilot2.desktop \
      --replace-fail 'Exec=Display_Pilot_2' 'Exec=${pname}'

    install -Dm444 ${finalAttrs.contents}/usr/share/icons/hicolor/scalable/apps/dp2_svg.svg \
      $out/share/icons/hicolor/scalable/apps/dp2_svg.svg
  '';

  meta = {
    description = "BenQ utility for controlling supported monitors";
    longDescription = ''
      Display Pilot 2 uses DDC/CI to control supported BenQ monitors. On NixOS,
      enable i2c support and add your user to the configured i2c group:

      ```
      hardware.i2c.enable = true;
      users.users.<name>.extraGroups = [ "i2c" ];
      ```

      BenQ supports the Linux version on Ubuntu 24.04.2 LTS with GNOME 46 and X11.
    '';
    homepage = "https://www.benq.com/en-us/monitor/software/display-pilot-2.html";
    downloadPage = "https://www.benq.com/en-us/support/downloads-faq/products/monitor/display-pilot-2/software-driver.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ khssnv ];
    mainProgram = "display-pilot-2";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
