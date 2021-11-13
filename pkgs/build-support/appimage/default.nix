{ lib
, bash
, binutils-unwrapped
, coreutils
, gawk
, libarchive
, pv
, squashfsTools
, buildFHSUserEnv
, pkgs
}:

rec {
  appimage-exec = pkgs.substituteAll {
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

  extract = args@{ name ? "${args.pname}-${args.version}", src, ... }: pkgs.runCommand "${name}-extracted" {
      buildInputs = [ appimage-exec ];
    } ''
      appimage-exec.sh -x $out ${src}
    '';

  # for compatibility, deprecated
  extractType1 = extract;
  extractType2 = extract;
  wrapType1 = wrapType2;

  wrapAppImage = args@{ name ? "${args.pname}-${args.version}", src, extraPkgs, ... }: buildFHSUserEnv
    (defaultFhsEnvArgs // {
      inherit name;

      targetPkgs = pkgs: [ appimage-exec ]
        ++ defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs pkgs;

      runScript = "appimage-exec.sh -w ${src} --";
    } // (removeAttrs args ([ "pname" "version" ] ++ (builtins.attrNames (builtins.functionArgs wrapAppImage)))));

  wrapType2 = args@{ name ? "${args.pname}-${args.version}", src, extraPkgs ? pkgs: [ ], ... }: wrapAppImage
    (args // {
      inherit name extraPkgs;
      src = extract { inherit name src; };
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
      gnome2.GConf
      freetype
      (curl.override { gnutlsSupport = true; sslSupport = false; })
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
      networkmanager098

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

      flac
      freeglut
      libjpeg
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

      # libraries not on the upstream include list, but nevertheless expected
      # by at least one appimage
      libtool.lib # for Synfigstudio
      xorg.libxshmfence # for apple-music-electron
      at-spi2-core
    ];
  };
}
