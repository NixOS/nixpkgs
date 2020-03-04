{ stdenv, libarchive, radare2, jq, buildFHSUserEnv, squashfsTools, writeScript }:

rec {

  extract = { name, src }: stdenv.mkDerivation {
    name = "${name}-extracted";
    inherit src;
    nativeBuildInputs = [ radare2 libarchive jq squashfsTools ];
    buildCommand = ''
      # https://github.com/AppImage/libappimage/blob/ca8d4b53bed5cbc0f3d0398e30806e0d3adeaaab/src/libappimage/utils/MagicBytesChecker.cpp#L45-L63
      eval $(r2 $src -nn -Nqc "p8j 3 @ 8" |
        jq -r '{appimageSignature: (.[:-1]|implode), appimageType: .[-1]}|
          @sh "appimageSignature=\(.appimageSignature) appimageType=\(.appimageType)"')

      # check AppImage signature
      if [[ "$appimageSignature" != "AI" ]]; then
        echo "Not an appimage."
        exit
      fi

      case "$appimageType" in
        1)
          mkdir $out
          bsdtar -x -C $out -f $src
          ;;

        2)
          # multiarch offset one-liner using same method as AppImage
          # see https://gist.github.com/probonopd/a490ba3401b5ef7b881d5e603fa20c93
          offset=$(r2 $src -nn -Nqc "pfj.elf_header @ 0" |\
            jq 'map({(.name): .value}) | add | .shoff + (.shnum * .shentsize)')

          unsquashfs -q -d $out -o $offset $src
          chmod go-w $out
          ;;

        # 3) get ready, https://github.com/TheAssassin/type3-runtime
        *) echo "Unsupported AppImage Type: $appimageType";;
      esac
    '';
  };

  extractType1 = extract;
  extractType2 = extract;

  wrapAppImage = args@{ name, src, extraPkgs, ... }: buildFHSUserEnv (defaultFhsEnvArgs // {
    inherit name;

    targetPkgs = pkgs: defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs pkgs;

    runScript = writeScript "run" ''
      #!${stdenv.shell}

      export APPDIR=${src}
      export APPIMAGE_SILENT_INSTALL=1
      cd $APPDIR
      exec ./AppRun "$@"
    '';
  } // (removeAttrs args (builtins.attrNames (builtins.functionArgs wrapAppImage))));

  wrapType1 = args@{ name, src, extraPkgs ? pkgs: [], ... }: wrapAppImage (args // {
    inherit name extraPkgs;
    src = extractType1 { inherit name src; };
  });

  wrapType2 = args@{ name, src, extraPkgs ? pkgs: [], ... }: wrapAppImage (args // {
    inherit name extraPkgs;
    src = extractType2 { inherit name src; };
  });

  defaultFhsEnvArgs = {
    name = "appimage-env";

    # Most of the packages were taken from the Steam chroot
    targetPkgs = pkgs: with pkgs; [
      gtk3
      bashInteractive
      gnome3.zenity
      python2
      xorg.xrandr
      which
      perl
      xdg_utils
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
      libav
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
      gstreamer
      gst-plugins-base
      libappindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      alsaLib

      harfbuzz
      e2fsprogs
      libgpgerror
      keyutils.lib
      libjack2
      fribidi
      p11-kit

      # libraries not on the upstream include list, but nevertheless expected
      # by at least one appimage
      libtool.lib # for Synfigstudio
      at-spi2-core
    ];
  };
}
