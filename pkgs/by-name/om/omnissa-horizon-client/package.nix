{
  stdenv,
  lib,
  buildFHSEnv,
  copyDesktopItems,
  fetchurl,
  gsettings-desktop-schemas,
  makeDesktopItem,
  makeWrapper,
  opensc,
  liberation_ttf,
  writeText,
  writeTextDir,
  configText ? "",
}:
let
  version = "2605";

  sysArch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
  # The downloaded archive also contains ARM binaries, but these have not been tested.

  # For USB support, ensure that /var/run/omnissa/<YOUR-UID>
  # exists and is owned by you. Then run omnissa-usbarbitrator as root.

  mainProgram = "horizon-client";

  # Horizon renders its broker/desktop launch-item (tile) labels with
  # "DejaVu Sans", but fails to instantiate the font when fontconfig resolves it
  # to a symlinked file -- which is exactly what nixpkgs' dejavu_fonts provides
  # (it is a symlink tree into dejavu-fonts-minimal). The labels then render as
  # blank boxes; the rest of the UI uses the GTK theme font and is unaffected.
  # Other toolkits load the same symlinked font without issue, so this is
  # specific to the client's font handling.
  #
  # The FHS sandbox bind-mounts the host's /etc/fonts, so the FHS environment's
  # own fontconfig does not apply. Point the client at a config that keeps the
  # host's fonts but maps "DejaVu Sans" onto a bundled, regular-file font
  # (Liberation Sans). This is deterministic and independent of the host's
  # font configuration.
  fontconfigFile = writeText "omnissa-horizon-fontconfig.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <include ignore_missing="yes">/etc/fonts/fonts.conf</include>
      <dir>${liberation_ttf}/share/fonts</dir>
      <match target="pattern">
        <test name="family" qual="any">
          <string>DejaVu Sans</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Liberation Sans</string>
        </edit>
      </match>
    </fontconfig>
  '';

  # This forces the default GTK theme (Adwaita) because Horizon is prone to
  # UI usability issues when using non-default themes, such as Adwaita-dark.
  wrapBinCommands = path: name: ''
    makeWrapper "$out/${path}/${name}" "$out/bin/${name}_wrapper" \
    --set GTK_THEME Adwaita \
    --set FONTCONFIG_FILE "${fontconfigFile}" \
    --suffix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
    --suffix LD_LIBRARY_PATH : "$out/lib/omnissa/horizon/crtbora:$out/lib/omnissa"
  '';

  omnissaHorizonClientFiles = stdenv.mkDerivation {
    pname = "omnissa-horizon-files";
    inherit version;
    src = fetchurl {
      url = "https://download3.omnissa.com/software/CART27FQ1_LIN_2603_TARBALL/Omnissa-Horizon-Client-Linux-2603-8.18.0-24120621798.tar.gz";
      hash = "sha256:acd30479cec91ee693bbd685880fa3834f3678f8dd336511bb9d732f134f71d7";
    };
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir ext
      find ${sysArch} -type f -print0 | xargs -0n1 tar -Cext --strip-components=1 -xf

      chmod -R u+w ext/usr/lib
      mv ext/usr $out
      cp -r ext/${sysArch}/include $out/
      cp -r ext/${sysArch}/lib $out/

      # Horizon includes a copy of libstdc++ which is loaded via $LD_LIBRARY_PATH
      # when it cannot detect a new enough version already present on the system.
      # The checks are distribution-specific and do not function correctly on NixOS.
      # Deleting the bundled library is the simplest way to force it to use our version.
      rm "$out/lib/omnissa/gcc/libstdc++.so.6"

      # This opensc library is required to support smartcard authentication during the
      # initial connection to Horizon.
      mkdir $out/lib/omnissa/horizon/pkcs11
      ln -s ${opensc}/lib/pkcs11/opensc-pkcs11.so $out/lib/omnissa/horizon/pkcs11/libopenscpkcs11.so

      ${wrapBinCommands "bin" "horizon-client"}
      ${wrapBinCommands "lib/omnissa/horizon/usb" "horizon-eucusbarbitrator"}
    '';
  };

  omnissaFHSUserEnv =
    pname:
    buildFHSEnv {
      inherit pname version;

      runScript = "${omnissaHorizonClientFiles}/bin/${pname}_wrapper";

      targetPkgs =
        pkgs: with pkgs; [
          at-spi2-atk
          atk
          cairo
          dbus
          file
          fontconfig
          freetype
          gdk-pixbuf
          glib
          gtk2
          gtk3-x11
          harfbuzz
          liberation_ttf
          libjpeg
          libpng
          libpulseaudio
          libtiff
          libudev0-shim
          libuuid
          libv4l
          pango
          pcsclite
          pixman
          udev
          omnissaHorizonClientFiles
          libx11
          libxau
          libxcursor
          libxext
          libxi
          libxinerama
          libxkbfile
          libxrandr
          libxrender
          libxscrnsaver
          libxtst
          zlib
          libxml2_13

          (writeTextDir "etc/omnissa/config" configText)
        ];
    };

  desktopItem = makeDesktopItem {
    name = "horizon-client";
    desktopName = "Omnissa Horizon Client";
    icon = "${omnissaHorizonClientFiles}/share/icons/horizon-client.png";
    exec = "${omnissaFHSUserEnv mainProgram}/bin/${mainProgram} %u";
    mimeTypes = [
      "x-scheme-handler/horizon-client"
      "x-scheme-handler/vmware-view"
    ];
  };

in
stdenv.mkDerivation {
  pname = "omnissa-horizon-client";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ln -s ${omnissaFHSUserEnv "horizon-client"}/bin/horizon-client $out/bin/
    ln -s ${omnissaFHSUserEnv "omnissa-usbarbitrator"}/bin/omnissa-usbarbitrator $out/bin/
    runHook postInstall
  '';

  unwrapped = omnissaHorizonClientFiles;

  passthru.updateScript = ./update.sh;

  meta = {
    inherit mainProgram;
    description = "Allows you to connect to your Omnissa Horizon virtual desktop";
    homepage = "https://www.omnissa.com/products/horizon-8/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mhutter ];
  };
}
