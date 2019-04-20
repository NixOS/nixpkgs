{ pkgs, stdenv, libarchive, patchelf, zlib, buildFHSUserEnv, writeScript }:

rec {
  # Both extraction functions could be unified, but then
  # it would depend on libmagic to correctly identify ISO 9660s

  extractType1 = { name, src }: stdenv.mkDerivation {
    name = "${name}-extracted";
    inherit src;

    nativeBuildInputs = [ libarchive ];
    buildCommand = ''
      mkdir $out
      bsdtar -x -C $out -f $src
    '';
  };

  extractType2 = { name, src }: stdenv.mkDerivation {
    name = "${name}-extracted";
    inherit src;

    nativeBuildInputs = [ patchelf ];
    buildCommand = ''
      install $src ./appimage
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --replace-needed libz.so.1 ${zlib}/lib/libz.so.1 \
        ./appimage

      ./appimage --appimage-extract

      cp -rv squashfs-root $out
    '';
  };

  wrapAppImage = { name, src, extraPkgs }: buildFHSUserEnv (defaultFhsEnvArgs // {
    inherit name;

    targetPkgs = pkgs: defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs pkgs;

    runScript = writeScript "run" ''
      #!${stdenv.shell}

      export APPDIR=${src}
      export APPIMAGE_SILENT_INSTALL=1
      cd $APPDIR
      exec ./AppRun "$@"
    '';
  });

  wrapType1 = args@{ name, src, extraPkgs ? pkgs: [] }: wrapAppImage {
    inherit name extraPkgs;
    src = extractType1 { inherit name src; };
  };

  wrapType2 = args@{ name, src, extraPkgs ? pkgs: [] }: wrapAppImage {
    inherit name extraPkgs;
    src = extractType2 { inherit name src; };
  };

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
      gdk_pixbuf

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
      mesa_noglu
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

      # libraries not on the upstream include list, but nevertheless expected
      # by at least one appimage
      libtool.lib # for Synfigstudio
    ];
  };
}
