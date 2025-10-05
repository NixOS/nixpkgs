{
  fdupes,
  buildFHSEnv,
  fetchzip,
  icoutils,
  imagemagick,
  jdk21,
  lib,
  makeDesktopItem,
  stdenvNoCC,
}:

let
  iconame = "STM32CubeMX";
  package = stdenvNoCC.mkDerivation rec {
    pname = "stm32cubemx";
    version = "6.14.0";

    src = fetchzip {
      url = "https://sw-center.st.com/packs/resource/library/stm32cube_mx_v${
        builtins.replaceStrings [ "." ] [ "" ] version
      }-lin.zip";
      hash = "sha256-GOvoPyfPdQV/gjveuFpZjueTZD/BYuEWSHgQKBm3o3A=";
      stripRoot = false;
    };

    nativeBuildInputs = [
      fdupes
      icoutils
      imagemagick
    ];
    desktopItem = makeDesktopItem {
      name = "STM32CubeMX";
      exec = "stm32cubemx";
      desktopName = "STM32CubeMX";
      categories = [ "Development" ];
      icon = "stm32cubemx";
      comment = meta.description;
      terminal = false;
      startupNotify = false;
      mimeTypes = [
        "x-scheme-handler/sgnl"
        "x-scheme-handler/signalcaptcha"
      ];
    };

    buildCommand = ''
      mkdir -p $out/{bin,opt/STM32CubeMX,share/applications}

      cp -r $src/MX/. $out/opt/STM32CubeMX/
      chmod +rx $out/opt/STM32CubeMX/STM32CubeMX

      cat << EOF > $out/bin/${pname}
      #!${stdenvNoCC.shell}
      updater_xml="\$HOME/.stm32cubemx/thirdparties/db/updaterThirdParties.xml"
      if [ -e "\$updater_xml" ] && [ ! -w "\$updater_xml" ]; then
        echo "Warning: Unwritable \$updater_xml prevents CubeMX software packages from working correctly. Fixing that."
        (set -x; chmod u+w "\$updater_xml")
      fi
      ${jdk21}/bin/java -jar $out/opt/STM32CubeMX/STM32CubeMX "\$@"
      EOF
      chmod +x $out/bin/${pname}

      icotool --extract $out/opt/STM32CubeMX/help/${iconame}.ico
      fdupes -dN . > /dev/null
      ls
      for size in 16 24 32 48 64 128 256; do
        mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
        if [ $size -eq 256 ]; then
          mv ${iconame}_*_"$size"x"$size"x32.png \
            $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
        else
          convert -resize "$size"x"$size" ${iconame}_*_256x256x32.png \
            $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
        fi
      done;

      cp ${desktopItem}/share/applications/*.desktop $out/share/applications
      if ! grep -q StartupWMClass= "$out"/share/applications/*.desktop; then
          chmod +w "$out"/share/applications/*.desktop
          echo "StartupWMClass=com-st-microxplorer-maingui-STM32CubeMX" >> "$out"/share/applications/*.desktop
      else
          echo "error: upstream already provides StartupWMClass= in desktop file -- please update package expr" >&2
          exit 1
      fi
    '';

    meta = with lib; {
      description = "Graphical tool for configuring STM32 microcontrollers and microprocessors";
      longDescription = ''
        A graphical tool that allows a very easy configuration of STM32
        microcontrollers and microprocessors, as well as the generation of the
        corresponding initialization C code for the Arm® Cortex®-M core or a
        partial Linux® Device Tree for Arm® Cortex®-A core), through a
        step-by-step process.
      '';
      homepage = "https://www.st.com/en/development-tools/stm32cubemx.html";
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
      license = licenses.unfree;
      maintainers = with maintainers; [
        angaz
        wucke13
      ];
      platforms = [ "x86_64-linux" ];
    };
  };
in
buildFHSEnv {
  inherit (package) pname version meta;
  runScript = "${package.outPath}/bin/stm32cubemx";
  extraInstallCommands = ''
    mkdir -p $out/share/{applications,icons}
    ln -sf ${package.outPath}/share/applications/* $out/share/applications/
    ln -sf ${package.outPath}/share/icons/* $out/share/icons/
  '';
  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      at-spi2-atk
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libGL
      libudev0-shim
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      xorg.libX11
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      libgcrypt
      openssl
      udev
    ];
}
