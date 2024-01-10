{ lib
, bash
, binutils-unwrapped
, coreutils
, gawk
, libarchive
, pv
, squashfsTools
, buildFHSEnv
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

  extract = args@{ name ? "${args.pname}-${args.version}", postExtract ? "", src, ... }: pkgs.runCommand "${name}-extracted" {
      buildInputs = [ appimage-exec ];
    } ''
      appimage-exec.sh -x $out ${src}
      ${postExtract}
    '';

  # for compatibility, deprecated
  extractType1 = extract;
  extractType2 = extract;
  wrapType1 = wrapType2;

  wrapAppImage = args@{
    name ? "${args.pname}-${args.version}",
    src,
    extraPkgs,
    meta ? {},
    ...
  }: buildFHSEnv
    (defaultFhsEnvArgs // {
      inherit name;

      targetPkgs = pkgs: [ appimage-exec ]
        ++ defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs pkgs;

      runScript = "appimage-exec.sh -w ${src} --";

      meta = {
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      } // meta;
    } // (removeAttrs args ([ "pname" "version" ] ++ (builtins.attrNames (builtins.functionArgs wrapAppImage)))));

  wrapType2 = args@{ name ? "${args.pname}-${args.version}", src, extraPkgs ? pkgs: [ ], ... }: wrapAppImage
    (args // {
      inherit name extraPkgs;
      src = extract { inherit name src; };

      # passthru src to make nix-update work
      # hack to keep the origin position (unsafeGetAttrPos)
      passthru = lib.pipe args [
        lib.attrNames
        (lib.remove "src")
        (removeAttrs args)
      ] // args.passthru or { };
    });

  defaultFhsEnvArgs = {
    name = "appimage-env";

    # Most of the packages were taken from the Steam chroot
    targetPkgs = pkgs: with pkgs; [
      gtk3
      bashInteractive
      gnome.zenity
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
      libthai
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
      pciutils # for FreeCAD
    ];
  };
}
