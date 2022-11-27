{ lib
, bash
, binutils-unwrapped
, coreutils
, gawk
, libarchive
, pv
, squashfsTools
, buildFHSUserEnv
, runCommand
, substituteAll
}:

rec {
  # for compatibility, deprecated. TODO: guard these behind config.allowAliases
  extractType1 = extract;
  extractType2 = extract;
  wrapType1 = wrapType2;

  appimage-exec = substituteAll {
    src = ./appimage-exec.sh;
    isExecutable = true;
    dir = "bin";
    path = lib.makeBinPath [
      bash
      binutils-unwrapped
      coreutils
      gawk
      libarchive
      pv
      squashfsTools
    ];
  };

  extract =
    { name ? "${args.pname}-${args.version}"
    , src
    , ...
    } @ args:
    runCommand "${name}-extracted"
      {
        nativeBuildInputs = [ appimage-exec ];
      } ''
      appimage-exec.sh -x $out ${src}
    '';

  wrapAppImage =
    { name ? "${args.pname}-${args.version}"
    , src
    , extraPkgs ? pkgs: [ ]
    , extraInstallCommands ? ""
    , meta ? { }
    , ...
    } @ args:
    buildFHSUserEnv (defaultFhsEnvArgs // {
      inherit name extraInstallCommands;

      targetPkgs = pkgs: [ appimage-exec ]
        ++ defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs pkgs;

      runScript = "appimage-exec.sh -w ${src} --";

      meta = {
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      } // meta;
    } // (removeAttrs args ([ "pname" "version" ] ++ (lib.attrNames (builtins.functionArgs wrapAppImage)))));

  wrapType2 =
    { name ? "${args.pname}-${args.version}"
    , src
    , extraPkgs ? pkgs: [ ]
    , extraInstall ? extracted: ""
    , ...
    } @ args:
    let
      extracted = extract { inherit name src; };
    in
    wrapAppImage (removeAttrs args [ "extraInstall" ] // {
      inherit name extraPkgs;
      src = extracted;

      extraInstallCommands = args.extraInstallCommands or ''
        # Dont include the version number in the binary name. It would be better
        # if we could do this in wrapAppImage, but that would break existing uses
        if [ -f "$out/bin/${name}" ]; then
          mv "$out/bin/${name}" "$out/bin/${lib.getName name}"
        fi

        # Appimages always have a desktop file, copy it to our output
        mkdir -p $out/share/applications
        cp ${extracted}/*.desktop $out/share/applications
      '' + extraInstall extracted;
    });

  defaultFhsEnvArgs = {
    name = "appimage-env";

    # Most of the packages were taken from the Steam chroot
    targetPkgs = pkgs: with pkgs; [
      gtk3
      bashInteractive
      gnome.zenity
      python2
      xorg.xrandr
      which
      perl
      xdg-utils
      iana-etc
      krb5
      gsettings-desktop-schemas
      hicolor-icon-theme # dont show a gtk warning about hicolor not being installed
    ];

    # list of libraries expected in an appimage environment:
    # https://github.com/AppImage/pkg2appimage/blob/master/excludelist
    multiPkgs = pkgs: with pkgs; [
      desktop-file-utils
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      libdrm
      xorg.xkeyboardconfig
      xorg.libpciaccess

      glib
      gtk2
      bzip2
      zlib
      gdk-pixbuf

      xorg.libXinerama
      xorg.libXdamage
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXxf86vm
      xorg.libXi
      xorg.libSM
      xorg.libICE
      freetype
      curlWithGnuTls
      nspr
      nss
      fontconfig
      cairo
      pango
      expat
      dbus
      cups
      libcap
      SDL2
      libusb1
      udev
      dbus-glib
      atk
      at-spi2-atk
      libudev0-shim

      xorg.libXt
      xorg.libXmu
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      libGLU
      libuuid
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      openssl
      libidn
      tbb
      wayland
      mesa
      libxkbcommon
      vulkan-loader

      flac
      freeglut
      libjpeg
      libpng12
      libpulseaudio
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
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      alsa-lib

      harfbuzz
      e2fsprogs
      libgpg-error
      keyutils.lib
      libjack2
      fribidi
      p11-kit

      gmp

      # libraries not on the upstream include list, but nevertheless expected
      # by at least one appimage
      libtool.lib # for Synfigstudio
      xorg.libxshmfence # for apple-music-electron
      at-spi2-core
    ];
  };
}
