{
  buildFHSEnv,
  symlinkJoin,
  bottles-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  removeWarningPopup ? false,
}:

let
  fhsEnv = {
    inherit (bottles-unwrapped) version;
    # Many WINE games need 32bit
    multiArch = true;

    targetPkgs =
      pkgs:
      with pkgs;
      [
        (bottles-unwrapped.override { inherit removeWarningPopup; })
        # This only allows to enable the toggle, vkBasalt won't work if not installed with environment.systemPackages (or nix-env)
        # See https://github.com/bottlesdevs/Bottles/issues/2401
        vkbasalt
      ]
      ++ extraPkgs pkgs;

    multiPkgs =
      let
        xorgDeps =
          pkgs: with pkgs.xorg; [
            libpthreadstubs
            libSM
            libX11
            libXaw
            libxcb
            libXcomposite
            libXcursor
            libXdmcp
            libXext
            libXi
            libXinerama
            libXmu
            libXrandr
            libXrender
            libXv
            libXxf86vm
          ];
        gstreamerDeps =
          pkgs: with pkgs.gst_all_1; [
            gstreamer
            gst-plugins-base
            gst-plugins-good
            gst-plugins-ugly
            gst-plugins-bad
            gst-libav
          ];
        waylandDeps =
          pkgs: with pkgs; [
            libxkbcommon
            wayland
          ];
      in
      pkgs:
      with pkgs;
      [
        # https://wiki.winehq.org/Building_Wine
        alsa-lib
        cups
        dbus
        fontconfig
        freetype
        glib
        gnutls
        libglvnd
        gsm
        libgphoto2
        libjpeg_turbo
        libkrb5
        libpcap
        libpng
        libpulseaudio
        libtiff
        libunwind
        libusb1
        libv4l
        libxml2
        mpg123
        ocl-icd
        openldap
        samba4
        sane-backends
        SDL2
        udev
        vulkan-loader

        # https://www.gloriouseggroll.tv/how-to-get-out-of-wine-dependency-hell/
        alsa-plugins
        dosbox
        giflib
        gtk3
        libva
        libxslt
        ncurses
        openal

        # Steam runtime
        libgcrypt
        libgpg-error
        p11-kit
        zlib # Freetype
      ]
      ++ xorgDeps pkgs
      ++ gstreamerDeps pkgs
      ++ extraLibraries pkgs
      ++ waylandDeps pkgs;
  };
in
symlinkJoin {
  name = "bottles";
  paths = [
    (buildFHSEnv (
      fhsEnv
      // {
        pname = "bottles";
        runScript = "bottles";
      }
    ))
    (buildFHSEnv (
      fhsEnv
      // {
        pname = "bottles-cli";
        runScript = "bottles-cli";
      }
    ))
  ];
  postBuild = ''
    mkdir -p $out/share
    ln -s ${bottles-unwrapped}/share/applications $out/share
    ln -s ${bottles-unwrapped}/share/icons $out/share
  '';

  inherit (bottles-unwrapped) meta;
}
