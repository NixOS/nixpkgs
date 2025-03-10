{
  lib,
  callPackage,
  buildFHSEnv,
  fetchzip,
  makeDesktopItem,
  writeShellScript,
  autoPatchelfHook,

  overrideSrc ? null,
  # A package. Omit to build without Everest.
  everest ? null,
  # If build with Everest, must set writableDir to the path of a writable dir
  # so that the mods can be installed there.
  # It must be an absolute path.
  # Example: "/home/kat/.local/share/Everest"
  writableDir ? null,
  # Optionally set paths of symlinks to the installation dir of Celeste.
  # You can use this in Olympus so that you don't have to change installation dir path
  # every time the nix store path changes.
  # The links are updated every time the command `celeste` is run.
  gameDir ? [ ],
  # This will be appended to everest-launch.txt.
  launchFlags ? "",
  # This will be appended to everest-env.txt.
  launchEnv ? "",
}:

let
  pname = "celeste";
  phome = "$out/${celesteHomeRelative}";
  executableName = "Celeste";

  writableDir' =
    if writableDir == null && everest != null then
      lib.warn "writableDir is not set, so mods will not work." "/tmp"
    else
      writableDir;
  gameDir' = lib.toList gameDir;

  everestLogFilename = "everest-log.txt";

  celeste = callPackage ./celeste {
    inherit
      everest
      overrideSrc
      launchFlags
      launchEnv
      everestLogFilename
      ;
    writableDir = writableDir';
  };
  celesteHomeRelative = "lib/Celeste";
  celesteHome = "${celeste}/${celesteHomeRelative}";

  desktopItem = makeDesktopItem {
    name = "Celeste";
    desktopName = "Celeste";
    genericName = "Celeste";
    comment = celeste.meta.description;
    exec = executableName;
    icon = "Celeste";
    categories = [ "Game" ];
  };

in
buildFHSEnv {
  inherit pname executableName;
  version = celeste.version + (lib.optionalString (everest != null) "+everest.${everest.version}");

  multiPkgs =
    pkgs:
    with pkgs;
    [
      glib
      glibc_multi
      kdePackages.wayland
      libxkbcommon
      libgcc
      mesa
      libdrm
      expat
      alsa-lib
      at-spi2-atk
      libGL
      pcre2
      libffi
      zlib
      util-linux.lib
      libselinux
      nspr
      systemd
      gtk3
      pango
      harfbuzz
      fontconfig
      fribidi
      cairo
      libepoxy
      tinysparql
      libthai
      libpng
      freetype
      pixman
      libcap
      graphite2
      bzip2
      brotli
      libjpeg
      json-glib
      libxml2
      sqlite
      libdatrie
      ffmpeg
      nss
      dbus.lib
      acl
      attr
      gmp
      readline
      libpulseaudio
      pipewire
    ]
    ++ (with xorg; [
      libX11
      libXcomposite
      libXdamage
      libXfixes
      libXext
      libxcb
      libXcursor
      libXinerama
      libXi
      libXrandr
      libXScrnSaver
      libXxf86vm
      libXau
      libXdmcp
    ]);

  targetPkgs = pkgs: [ celeste ];

  extraInstallCommands = ''
    icon=$out/share/icons/hicolor/512x512/apps/Celeste.png
    mkdir -p $(dirname $icon)
    ln -s ${celesteHome}/Celeste.png $icon
    cp -r ${desktopItem}/* $out
  '';

  runScript = writeShellScript executableName (
    lib.optionalString (writableDir' != null) ''
      mkdir -p "${writableDir'}"
      touch "${writableDir'}/log.txt"
    ''
    + lib.optionalString (everest != null) ''
      mkdir -p "${writableDir'}"/{LogHistory,Mods,CrashLogs}
      touch "${writableDir'}/${everestLogFilename}"
    ''
    + lib.optionalString (gameDir' != [ ]) (
      lib.concatMapStrings (link: ''
        mkdir -p "$(dirname "${link}")"
        if [ -L "${link}" ]; then
          if [ ${celesteHome} != "$(readlink "${link}")" ]; then
            rm "${link}"
            ln -s ${celesteHome} "${link}"
          fi
        else
          rm -r "${link}"
          ln -s ${celesteHome} "${link}"
        fi
      '') gameDir'
    )
    + ''
      cd /${celesteHomeRelative}
      exec ./Celeste "$@"
    ''
  );

  passthru.celeste-unwrapped = celeste;
  passthru.everest = callPackage ./everest { };
  passthru.everest-bin = callPackage ./everest-bin { };

  meta = {
    inherit (celeste.meta)
      homepage
      downloadPage
      description
      license
      sourceProvenance
      platforms
      ;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
}
