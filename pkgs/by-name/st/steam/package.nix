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
  withGameSpecificLibraries ? false, # include game specific libraries
}:
let
  steamEnv = { name, runScript, passthru ? {}, meta ? {} }:
  buildFHSEnv {
    inherit name runScript passthru meta;

    multiArch = true;

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

    multiPkgs = pkgs: with pkgs; [
      # These are required by steam with proper errors
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libva
      pipewire

      # steamwebhelper
      harfbuzz
      libthai
      pango

      lsof # friends options won't display "Launch Game" without it
      file # called by steam's setup.sh

      # dependencies for mesa drivers, needed inside pressure-vessel
      mesa.llvmPackages.llvm.lib
      vulkan-loader
      expat
      wayland
      xorg.libxcb
      xorg.libXdamage
      xorg.libxshmfence
      xorg.libXxf86vm
      elfutils

      # Without these it silently fails
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXi
      xorg.libSM
      xorg.libICE
      curl
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      gsettings-desktop-schemas
      ffmpeg
      libudev0-shim

      # Verified games requirements
      fontconfig
      freetype
      xorg.libXt
      xorg.libXmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      libdrm
      libidn
      tbb
      zlib

      # SteamVR
      udev
      dbus

      # Other things from runtime
      glib
      gtk2
      bzip2
      flac
      libglut
      libjpeg
      libpng
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libdbusmenu-gtk2
      libindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libunwind
      libvpx
      librsvg
      xorg.libXft
      libvdpau

      # required by coreutils stuff to run correctly
      # Steam ends up with LD_LIBRARY_PATH=/usr/lib:<bunch of runtime stuff>:<etc>
      # which overrides DT_RUNPATH in our binaries, so it tries to dynload the
      # very old versions of stuff from the runtime.
      # FIXME: how do we even fix this correctly
      attr
      # same thing, but for Xwayland (usually via gamescope), already in the closure
      libkrb5
      keyutils
    ] ++ lib.optionals withGameSpecificLibraries [
      # Not formally in runtime but needed by some games
      at-spi2-atk
      at-spi2-core   # CrossCode
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      json-glib # paradox launcher (Stellaris)
      libxkbcommon # paradox launcher
      libvorbis # Dead Cells
      libxcrypt # Alien Isolation, XCOM 2, Company of Heroes 2
      mono
      ncurses # Crusader Kings III
      openssl
      xorg.xkeyboardconfig
      xorg.libpciaccess
      xorg.libXScrnSaver # Dead Cells
      icu # dotnet runtime, e.g. Stardew Valley

      # screeps dependencies
      gtk3
      zlib
      atk
      cairo
      gdk-pixbuf

      # Prison Architect
      libGLU
      libuuid
      libbsd
      alsa-lib

      # Loop Hero
      # FIXME: Also requires openssl_1_1, which is EOL. Either find an alternative solution, or remove these dependencies (if not needed by other games)
      libidn2
      libpsl
      nghttp2.lib
      rtmpdump
    ]
    ++ extraLibraries pkgs;

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
