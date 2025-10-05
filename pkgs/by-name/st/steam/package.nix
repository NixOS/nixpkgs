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
  privateTmp ? true, # if the steam bubblewrap should isolate /tmp
}:
let
  buildRuntimeEnv =
    {
      extraPkgs ? pkgs: [ ],
      extraLibraries ? pkgs: [ ],
      extraProfile ? "",
      extraPreBwrapCmds ? "",
      extraBwrapArgs ? [ ],
      extraEnv ? { },
      privateTmp ? true,
      ...
    }@args:
    buildFHSEnv (
      (removeAttrs args [
        "extraPkgs"
        "extraLibraries"
        "extraProfile"
        "extraPreBwrapCmds"
        "extraBwrapArgs"
        "extraArgs"
        "extraEnv"
      ])
      // {
        inherit privateTmp;

        multiArch = true;
        includeClosures = true;

        # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#command-line-tools
        targetPkgs =
          pkgs:
          with pkgs;
          [
            bash
            coreutils
            file
            lsb-release # not documented, called from Big Picture
            pciutils # not documented, complains about lspci on startup
            glibc_multi.bin
            xdg-utils # calls xdg-open occasionally
            xz
            zenity

            # Steam expects it to be /sbin specifically
            (pkgs.runCommand "sbin-ldconfig" { } ''
              mkdir -p $out/sbin
              ln -s /bin/ldconfig $out/sbin/ldconfig
            '')

            # crashes on startup if it can't find libX11 locale files
            (pkgs.runCommand "xorg-locale" { } ''
              mkdir -p $out
              ln -s ${xorg.libX11}/share $out/share
            '')
          ]
          ++ extraPkgs pkgs;

        # https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#shared-libraries
        multiPkgs =
          pkgs:
          with pkgs;
          [
            glibc
            libxcrypt
            libGL

            libdrm
            libgbm
            udev
            libudev0-shim
            libva
            vulkan-loader

            networkmanager
            # not documented, used for network status things in Big Picture
            # FIXME: figure out how to only build libnm?
            libcap # not documented, required by srt-bwrap
          ]
          ++ extraLibraries pkgs;

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

          # Steam gets confused by the symlinks to bind mounts to symlinks /etc/localtime ends up being, so help it out.
          # See also: https://github.com/flathub/com.valvesoftware.Steam/blob/28481f09f33c12b6ac7421d13af9ed1523c54ec4/steam_wrapper/steam_wrapper.py#L160
          if [ -z ''${TZ+x} ]; then
            new_TZ="$(readlink -f /etc/localtime | grep -P -o '(?<=/zoneinfo/).*$')"
            if [ $? -eq 0 ]; then
              export TZ="$new_TZ"
            fi
          fi

          set -a
          ${lib.toShellVars extraEnv}
          set +a

          ${extraProfile}
        '';

        inherit extraPreBwrapCmds;

        extraBwrapArgs = [
          # Steam will dump crash reports here, make those more accessible
          "--bind-try /tmp/dumps /tmp/dumps"
        ]
        ++ extraBwrapArgs;
      }
    );
in
buildRuntimeEnv {
  pname = "steam";
  inherit (steam-unwrapped) version meta;

  extraPkgs = pkgs: [ steam-unwrapped ] ++ extraPkgs pkgs;
  inherit
    extraLibraries
    extraProfile
    extraPreBwrapCmds
    extraBwrapArgs
    extraEnv
    privateTmp
    ;

  runScript = writeShellScript "steam-wrapped" ''
    exec steam ${extraArgs} "$@"
  '';

  extraInstallCommands = ''
    ln -s ${steam-unwrapped}/share $out/share
  '';

  passthru =
    let
      makeSteamRun =
        package:
        buildRuntimeEnv {
          name = "steam-run";

          extraPkgs = pkgs: package ++ extraPkgs pkgs;

          inherit
            extraLibraries
            extraProfile
            extraPreBwrapCmds
            extraBwrapArgs
            extraEnv
            privateTmp
            ;

          runScript = writeShellScript "steam-run" ''
            if [ $# -eq 0 ]; then
              echo "Usage: steam-run command-to-run args..." >&2
              exit 1
            fi

            exec "$@"
          '';

          meta = {
            description = "Run commands in the same FHS environment that is used for Steam";
            mainProgram = "steam-run";
            name = "steam-run";
            license = lib.licenses.mit;
          };
        };
    in
    {
      inherit buildRuntimeEnv;

      run = makeSteamRun [ steam-unwrapped ];
      run-free = makeSteamRun [ ];
    };
}
