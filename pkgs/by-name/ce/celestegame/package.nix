{
  lib,
  callPackage,
  buildFHSEnv,
  fetchzip,
  makeDesktopItem,
  writeShellScript,
  autoPatchelfHook,
  runtimeShell,
  # Override this to everest-bin if you want to use steam-run.
  everest,

  withEverest ? false,
  overrideSrc ? null,
  # If build with Everest, must set writableDir to the path of a writable dir
  # so that the mods can be installed there.
  # It must be an absolute path.
  # Example: "/home/kat/.local/share/Everest"
  writableDir ? null,
  # Optionally set paths of symlinks to the installation dir of Celeste.
  # You can use this in Olympus so that you don't have to change installation dir path
  # every time the nix store path changes.
  # The links are updated every time the command `Celeste` is run.
  gameDir ? [ ],
  # This will be appended to everest-launch.txt.
  launchFlags ? "",
  # This will be appended to everest-env.txt.
  launchEnv ? "",
}:

# For those who would like to use steam-run or alike to launch Celeste
# (useful when using the `olympus` package with its `celesteWrapper` argument overridden),
# install `celestegame.passthru.celeste-unwrapped` instead of `celestegame`,
# and if you want Everest, override `everest` to `everest-bin`
# (steam-run cannot launch the latter for some currently unclear reason).
# For those who would like to launch Celeste without the need of any additional wrapper like steam-run,
# install `celestegame` with the `writableDir` argument overridden.

let
  pname = "celeste";
  phome = "$out/${celesteHomeRelative}";
  executableName = "Celeste";

  writableDir' =
    if writableDir == null && withEverest then
      lib.warn "writableDir is not set, so mods will not work." "/tmp"
    else
      writableDir;
  gameDir' = lib.toList gameDir;

  everestLogFilename = "everest-log.txt";

  celeste = callPackage ./celeste.nix {
    inherit
      executableName
      everest
      withEverest
      overrideSrc
      launchFlags
      launchEnv
      everestLogFilename
      ;
    desktopItems = [ desktopItem ];
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
  version = celeste.version + (lib.optionalString withEverest "+everest.${everest.version}");

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
      vulkan-loader
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

  extraPreBwrapCmds = ''
    export NIX_CELESTE_LAUNCHER=$(realpath --no-symlinks $0)
  '';

  runScript = writeShellScript executableName (
    lib.optionalString (writableDir' != null) ''
      mkdir -p "${writableDir'}"
      touch "${writableDir'}/log.txt"

      # This script is symlinked to gameDir/Celeste, which gets launched by Olympus
      # (if the user set up Olympus to use gameDir as the location of Celeste).
      # Writing the script like this makes Olympus able to launch Celeste wihout any wrapper without any problems.
      echo "#! ${runtimeShell}
      exec $NIX_CELESTE_LAUNCHER"' "$@"' > "${writableDir'}/Celeste"
      chmod +x "${writableDir'}/Celeste"
    ''
    + lib.optionalString withEverest ''
      mkdir -p "${writableDir'}"/{LogHistory,Mods,CrashLogs}
      touch "${writableDir'}/${everestLogFilename}"

      # Needed to prevent restarting; see comments in postInstall of ./celeste/default.nix.
      export LD_LIBRARY_PATH="${celesteHome}/lib64-linux:$LD_LIBRARY_PATH"
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
      exec ./Celeste-unwrapped "$@"
    ''
  );

  passthru.celeste-unwrapped = celeste;

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
