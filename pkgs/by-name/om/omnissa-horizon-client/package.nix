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
  writeTextDir,
  configText ? "",
}:
let
  version = "2503";

  sysArch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "x64"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
  # The downloaded archive also contains ARM binaries, but these have not been tested.

  # For USB support, ensure that /var/run/omnissa/<YOUR-UID>
  # exists and is owned by you. Then run omnissa-usbarbitrator as root.

  mainProgram = "horizon-client";

  # This forces the default GTK theme (Adwaita) because Horizon is prone to
  # UI usability issues when using non-default themes, such as Adwaita-dark.
  wrapBinCommands = path: name: ''
    makeWrapper "$out/${path}/${name}" "$out/bin/${name}_wrapper" \
    --set GTK_THEME Adwaita \
    --suffix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
    --suffix LD_LIBRARY_PATH : "$out/lib/omnissa/horizon/crtbora:$out/lib/omnissa"
  '';

  omnissaHorizonClientFiles = stdenv.mkDerivation {
    pname = "omnissa-horizon-files";
    inherit version;
    src = fetchurl {
      url = "https://download3.omnissa.com/software/CART26FQ1_LIN_2503_TARBALL/Omnissa-Horizon-Client-Linux-2503-8.15.0-14256322247.tar.gz";
      sha256 = "c7df084d717dc70ce53eadfbe5a9d0daa06931b640702a8355705fbd93e16bb4";
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
          xorg.libX11
          xorg.libXau
          xorg.libXcursor
          xorg.libXext
          xorg.libXi
          xorg.libXinerama
          xorg.libxkbfile
          xorg.libXrandr
          xorg.libXrender
          xorg.libXScrnSaver
          xorg.libXtst
          zlib

          # c.f. https://github.com/NixOS/nixpkgs/pull/418543
          (libxml2.overrideAttrs (oldAttrs: rec {
            version = "2.13.8";
            src = fetchurl {
              url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
              hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
            };
            meta = oldAttrs.meta // {
              knownVulnerabilities = oldAttrs.meta.knownVulnerabilities or [ ] ++ [
                "CVE-2025-49794"
                "CVE-2025-49796"
                "CVE-2025-6021"
              ];
            };
          }))

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

  meta = with lib; {
    inherit mainProgram;
    description = "Allows you to connect to your Omnissa Horizon virtual desktop";
    homepage = "https://www.omnissa.com/products/horizon-8/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ mhutter ];
  };
}
