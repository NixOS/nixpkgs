{
  pname,
  version,
  src,
  meta,
  binaryName,
  desktopName,
  autoPatchelfHook,
  makeDesktopItem,
  lib,
  stdenv,
  wrapGAppsHook3,
  makeShellWrapper,
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
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libappindicator-gtk3,
  libdbusmenu,
  writeScript,
  writeScriptBin,
  python3,
  runCommand,
  libunity,
  speechd-minimal,
  wayland,
  branch,
  sway,
  jq,
  procps,
  withOpenASAR ? false,
  openasar,
  withVencord ? false,
  vencord,
  withTTS ? true,
}:

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
in

stdenv.mkDerivation (finalAttrs: rec {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
    cups
    libdrm
    libuuid
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxcb
    libxshmfence
    mesa
    nss
    wrapGAppsHook3
    makeShellWrapper
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath (
    [
      libcxx
      systemd
      libpulseaudio
      libdrm
      mesa
      stdenv.cc.cc
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libglvnd
      libnotify
      libX11
      libXcomposite
      libunity
      libuuid
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      nspr
      libxcb
      pango
      libXScrnSaver
      libappindicator-gtk3
      libdbusmenu
      wayland
    ]
    ++ lib.optional withTTS speechd-minimal
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/${binaryName},share/pixmaps,share/icons/hicolor/256x256/apps}
    mv * $out/opt/${binaryName}

    chmod +x $out/opt/${binaryName}/${binaryName}
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
        $out/opt/${binaryName}/${binaryName}

    wrapProgramShell $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \
        ${lib.strings.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/${binaryName} \
        --run "${lib.getExe disableBreakingUpdates}"

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true

    ln -s $out/opt/${binaryName}/discord.png $out/share/pixmaps/${pname}.png
    ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png

    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString withOpenASAR ''
      cp -f ${openasar} $out/opt/${binaryName}/resources/app.asar
    ''
    + lib.strings.optionalString withVencord ''
      mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
      mkdir $out/opt/${binaryName}/resources/app.asar
      echo '{"name":"discord","main":"index.js"}' > $out/opt/${binaryName}/resources/app.asar/package.json
      echo 'require("${vencord}/patcher.js")' > $out/opt/${binaryName}/resources/app.asar/index.js
    '';

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
  };

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
    test-run-in-sway = writeScriptBin "discord-in-sway" ''
      #! /usr/bin/env nix-shell
      #! nix-shell -i bash -p bash sway dbus procps
      # shellcheck shell=bash
      set -xeu

      export NIXOS_OZONE_WL=1
      export WLR_BACKENDS=headless
      export WLR_HEADLESS_OUTPUTS=1
      export WLR_LIBINPUT_NO_DEVICES=1

      export tempdir=$(mktemp -d)

      export XDG_RUNTIME_DIR=$tempdir
      export HOME=$tempdir
      export SWAYSOCK=$tempdir/sway_discord.sock
      sdconf=$tempdir/swaydiscordconfig

      rm -f "$SWAYSOCK"
      touch "$sdconf"

      # shellcheck disable=SC2317
      function cleanup {
          pgrep -f "$sdconf" | xargs -r kill
          # Can't remove, is busy...
          # rm: cannot remove '/run/user/1000/tmp.Yt9aLBLszq/gvfs': Device or resource busy
          # rm: cannot remove '/run/user/1000/tmp.Yt9aLBLszq/doc/by-app': Operation not permitted
          # rm -rf "$tempdir"
      }

      trap cleanup EXIT

      dbus-launch --config-file=${dbus}/share/dbus-1/session.conf \
        sway --config "$sdconf" &

      sleep 5
      swaymsg exec "${finalAttrs.finalPackage}/bin/${binaryName}"

      sub=$(timeout 15s swaymsg --socket "$SWAYSOCK" -t subscribe '["window"]')

      sleep 10

      if [[ "$(echo "$sub" | jq -r '.container | .app_id')" == discord ]]; then
          kill "$(jq '.container | .pid' <<< "$sub")"
          exit 0
      else
          exit 1
      fi
    '';
  };
})
