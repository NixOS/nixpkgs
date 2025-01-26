{
  lib,
  steam-unwrapped,
  buildFHSEnv,
  writeShellScript,
  extraPkgs ? pkgs: [ ], # extra packages to add to targetPkgs
  extraLibraries ? pkgs: [ ], # extra packages to add to multiPkgs
  extraProfile ? "", # string to append to profile
  extraPreBwrapCmds ? "", # extra commands to run before calling bubblewrap
  extraBwrapArgs ? [ ], # extra arguments to pass to bubblewrap (real default is at usage site)
  extraArgs ? "", # arguments to always pass to steam
  extraEnv ? { }, # Environment variables to pass to Steam
}:
let
  steamEnv = { name, runScript, passthru ? {}, meta ? {} }:
  buildFHSEnv {
    inherit name runScript passthru meta;

    multiArch = true;
    includeClosures = true;

    # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#command-line-tools
    targetPkgs = pkgs: with pkgs; [
      steam-unwrapped

      bash
      coreutils
      file
      lsb-release  # not documented, called from Big Picture
      pciutils  # not documented, complains about lspci on startup
      glibc_multi.bin
      xz
      zenity

      # Steam expects it to be /sbin specifically
      (pkgs.runCommand "sbin-ldconfig" {} ''
        mkdir -p $out/sbin
        ln -s /bin/ldconfig $out/sbin/ldconfig
      '')

      # crashes on startup if it can't find libX11 locale files
      (pkgs.runCommand "xorg-locale" {} ''
        mkdir -p $out
        ln -s ${xorg.libX11}/share $out/share
      '')
    ] ++ extraPkgs pkgs;

    # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#shared-libraries
    multiPkgs = pkgs: with pkgs; [
      glibc
      libxcrypt
      libGL

      libdrm
      libgbm
      udev
      libudev0-shim
      libva
      vulkan-loader

      networkmanager  # not documented, used for network status things in Big Picture
                      # FIXME: figure out how to only build libnm?
      libcap  # not documented, required by srt-bwrap
    ] ++ extraLibraries pkgs;

    extraInstallCommands = lib.optionalString (steam-unwrapped != null) ''
      ln -s ${steam-unwrapped}/share $out/share
    '';

    profile = ''
      # prevents log spam from SteamRT GTK trying to load host GIO modules
      unset GIO_EXTRA_MODULES

      # udev event notifications don't work reliably inside containers.
      # SDL2 already tries to automatically detect flatpak and pressure-vessel
      # and falls back to inotify-based discovery [1]. We make SDL2 do the
      # same by telling it explicitly.
      #
      # [1] <https://github.com/libsdl-org/SDL/commit/8e2746cfb6e1f1a1da5088241a1440fd2535e321>
      export SDL_JOYSTICK_DISABLE_UDEV=1

      # This is needed for IME (e.g. iBus, fcitx5) to function correctly on non-CJK locales
      # https://github.com/ValveSoftware/steam-for-linux/issues/781#issuecomment-2004757379
      export GTK_IM_MODULE='xim'

      # See https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#graphics-driver
      export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
      export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d
      export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
      export VDPAU_DRIVER_PATH=/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau

      set -a
      ${lib.toShellVars extraEnv}
      set +a

      ${extraProfile}
    '';

    privateTmp = true;

    inherit extraPreBwrapCmds;

    extraBwrapArgs = [
      # Steam will dump crash reports here, make those more accessible
      "--bind-try /tmp/dumps /tmp/dumps"
    ] ++ extraBwrapArgs;
  };
in steamEnv {
  name = "steam";

  runScript = writeShellScript "steam-wrapped" ''
    exec steam ${extraArgs} "$@"
  '';

  passthru.run = steamEnv {
    name = "steam-run";

    runScript = writeShellScript "steam-run" ''
      if [ $# -eq 0 ]; then
        echo "Usage: steam-run command-to-run args..." >&2
        exit 1
      fi

      exec "$@"
    '';

    meta = (steam-unwrapped.meta or {}) // {
      description = "Run commands in the same FHS environment that is used for Steam";
      mainProgram = "steam-run";
      name = "steam-run";
      # steam-run itself is just a script that lives in nixpkgs (which is licensed under MIT).
      # steam is a dependency and already unfree, so normal steam-run will not install without
      # allowing unfree packages or appropriate `allowUnfreePredicate` rules.
      license = lib.licenses.mit;
    };
  };

  meta = (steam-unwrapped.meta or {}) // {
    description = "Steam dependencies (dummy package, do not use)";
  };
}
