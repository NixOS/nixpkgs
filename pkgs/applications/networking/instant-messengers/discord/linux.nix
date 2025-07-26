{
  pname,
  version,
  src,
  meta,
  binaryName,
  desktopName,
  buildFHSEnv,
  makeDesktopItem,
  lib,
  stdenv,
  writeScript,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libcxx,
  libdrm,
  libglvnd,
  libnotify,
  libpulseaudio,
  libuuid,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  libxshmfence,
  libgbm,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libappindicator-gtk3,
  libdbusmenu,
  pipewire,
  python3,
  runCommand,
  speechd-minimal,
  wayland,
  xorg,
  branch,
  withOpenASAR ? false,
  openasar,
  withVencord ? false,
  vencord,
  withMoonlight ? false,
  moonlight,
  withTTS ? true,
  enableAutoscroll ? false,
  # Disabling this would normally break Discord.
  # The intended use-case for this is when SKIP_HOST_UPDATE is enabled via other means,
  # for example if a settings.json is linked declaratively (e.g., with home-manager).
  disableUpdates ? true,
  commandLineArgs ? "",
}:
assert lib.assertMsg (
  !(withMoonlight && withVencord)
) "discord: Moonlight and Vencord can not be enabled at the same time";
let
  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = "${python3.interpreter}";
        configDirName = lib.toLower binaryName;
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';

  # Create the Discord application directory
  discordDir = stdenv.mkDerivation {
    name = "${pname}-${version}-dir";
    inherit src;
    
    # Disable automatic patching that could modify binaries
    dontPatchELF = true;
    dontStrip = true;
    dontPatchShebangs = true;
    
    dontBuild = true;
    dontConfigure = true;
    
    installPhase = ''
      runHook preInstall
      
      mkdir -p $out/opt/${binaryName}
      mv * $out/opt/${binaryName}
      cd $out/opt

      # Apply modifications (do NOT chmod the binary - it breaks Krisp checksum validation)
      ${lib.optionalString withOpenASAR ''
        cp -f ${openasar} resources/app.asar
      ''}
      ${lib.optionalString withVencord ''
        mv resources/app.asar resources/_app.asar
        mkdir resources/app.asar
        echo '{"name":"discord","main":"index.js"}' > resources/app.asar/package.json
        echo 'require("${vencord}/patcher.js")' > resources/app.asar/index.js
      ''}
      ${lib.optionalString withMoonlight ''
        mv resources/app.asar resources/_app.asar
        mkdir resources/app
        echo '{"name":"discord","main":"injector.js","private": true}' > resources/app/package.json
        echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > resources/app/injector.js
      ''}
      
      runHook postInstall
    '';
  };

  # FHS Environment with all necessary libraries
  fhsEnv = buildFHSEnv {
    name = "${pname}-fhs";
    
    targetPkgs = pkgs: with pkgs; [
      # Core system libraries
      stdenv.cc.cc.lib
      glibc
      
      # Graphics and display
      libglvnd
      mesa
      libdrm
      libgbm
      wayland
      
      # X11 libraries
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
      xorg.libxcb
      xorg.libxshmfence
      
      # GTK and desktop integration
      gtk3
      glib
      cairo
      pango
      gdk-pixbuf
      atk
      at-spi2-atk
      at-spi2-core
      libappindicator-gtk3
      libdbusmenu
      
      # Audio
      alsa-lib
      libpulseaudio
      pipewire
      
      # Other system libraries
      dbus
      systemd
      fontconfig
      freetype
      expat
      libuuid
      cups
      nspr
      nss
      libnotify
      libcxx
      libxkbcommon
    ] ++ lib.optional withTTS pkgs.speechd-minimal;
    
    multiPkgs = pkgs: [
      # Additional 32-bit libraries if needed
      pkgs.alsa-lib
      pkgs.libpulseaudio
    ];
    
    # Set up the runtime environment
    runScript = writeScript "${pname}-wrapper" ''
      #!/bin/bash
      
      # Run the disable updates script if enabled
      ${lib.optionalString disableUpdates ''
        ${lib.getExe disableBreakingUpdates}
      ''}
      
      # Set up environment variables
      export XDG_DATA_DIRS="${gtk3}/share/gsettings-schemas/${gtk3.name}/:$XDG_DATA_DIRS"
      
      # Handle Wayland
      if [[ -n "$NIXOS_OZONE_WL" && -n "$WAYLAND_DISPLAY" ]]; then
        WAYLAND_FLAGS="--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true"
      fi
      
      # Handle TTS
      ${lib.optionalString withTTS ''
        if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then
          export NIXOS_SPEECH=True
          TTS_FLAGS="--enable-speech-dispatcher"
        fi
      ''}
      
      # Handle autoscroll
      ${lib.optionalString enableAutoscroll ''
        AUTOSCROLL_FLAGS="--enable-blink-features=MiddleClickAutoscroll"
      ''}
      
      # Execute Discord
      exec ${discordDir}/opt/${binaryName}/${binaryName} \
        --no-sandbox \
        --disable-gpu-sandbox \
        $WAYLAND_FLAGS \
        $TTS_FLAGS \
        $AUTOSCROLL_FLAGS \
        ${lib.escapeShellArg commandLineArgs} \
        "$@"
    '';
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/discord" ];
    startupWMClass = "discord";
  };
in
stdenv.mkDerivation {
  inherit pname version meta;
  
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;
  
  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/icons/hicolor/256x256/apps
    
    # Install the FHS wrapper
    ln -s ${fhsEnv}/bin/${pname}-fhs $out/bin/${binaryName}
    ln -s ${fhsEnv}/bin/${pname}-fhs $out/bin/${lib.strings.toLower binaryName}
    
    # Install icons
    ln -s ${discordDir}/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png
    ln -s ${discordDir}/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    
    # Install desktop file
    ln -s ${desktopItem}/share/applications/${pname}.desktop $out/share/applications/
    
    runHook postInstall
  '';
  
  passthru = {
    # make it possible to run disableBreakingUpdates standalone
    inherit disableBreakingUpdates;
    updateScript = writeScript "discord-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep common-updater-scripts
      set -eou pipefail;
      url=$(curl -sI -o /dev/null -w '%header{location}' "https://discord.com/api/download/${branch}?platform=linux&format=tar.gz")
      version=$(echo $url | grep -oP '/\K(\d+\.){2}\d+')
      update-source-version ${pname} "$version" --file=./pkgs/applications/networking/instant-messengers/discord/default.nix --version-key=${branch}
    '';
  };
}
