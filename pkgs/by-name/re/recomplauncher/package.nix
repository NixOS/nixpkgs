{
  lib,
  recomplauncher-unwrapped,
  steam,
  umu-launcher,
  vkbasalt,
  extraEnv ? { },
  extraLibraries ? pkgs: [ ],
  extraPkgs ? pkgs: [ ],
}:

steam.buildRuntimeEnv {
  inherit (recomplauncher-unwrapped) version;
  inherit extraEnv;

  pname = "recomplauncher";

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${recomplauncher-unwrapped}/share/applications $out/share
    ln -s ${recomplauncher-unwrapped}/share/icons $out/share
  '';

  extraLibraries =
    pkgs:
    with pkgs;
    [
      alsa-lib
      bzip2
      curl
      fontconfig
      freetype
      gtk3
      libice
      libpng
      libpulseaudio
      libsm
      libx11
      libxcursor
      libxext
      libxi
      libxinerama
      libxkbcommon
      libxrandr
      libxscrnsaver
      openal
      openssl
      pipewire
      sdl2-compat
      sdl3
      wayland
      zlib
      zstd
    ]
    ++ extraLibraries pkgs;

  extraPkgs =
    pkgs:
    [
      recomplauncher-unwrapped
      umu-launcher
      vkbasalt
    ]
    ++ extraPkgs pkgs;

  # game shortcuts start the wrapper, not the store path
  extraPreBwrapCmds = ''
    if [ -z "''${RL_START_PATH:-}" ]; then
      RL_START_PATH=$(command -v recomplauncher || printf '%s' "$0")
      case "$RL_START_PATH" in
        /*) ;;
        *) RL_START_PATH="$PWD/$RL_START_PATH" ;;
      esac
      export RL_START_PATH
    fi
    export RL_HOST_GTK_IM_MODULE="''${GTK_IM_MODULE-}"
  '';

  # steam runtime forces GTK_IM_MODULE=xim
  extraProfile = ''
    if [ -n "$RL_HOST_GTK_IM_MODULE" ]; then
      export GTK_IM_MODULE="$RL_HOST_GTK_IM_MODULE"
    else
      unset GTK_IM_MODULE
    fi
    unset RL_HOST_GTK_IM_MODULE
  '';

  privateTmp = false;
  runScript = lib.getExe recomplauncher-unwrapped;

  meta = recomplauncher-unwrapped.meta // {
    platforms = [ "x86_64-linux" ];
  };
}
