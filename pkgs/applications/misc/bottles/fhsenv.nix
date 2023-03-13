{ lib
, buildFHSUserEnvBubblewrap
, symlinkJoin
, bottles-unwrapped
, gst_all_1
, extraPkgs ? pkgs: [ ]
, extraLibraries ? pkgs: [ ]
}:

let fhsEnv = {
  targetPkgs = pkgs: with pkgs; [
    bottles-unwrapped
    # This only allows to enable the toggle, vkBasalt won't work if not installed with environment.systemPackages (or nix-env)
    # See https://github.com/bottlesdevs/Bottles/issues/2401
    vkbasalt
  ] ++ extraPkgs pkgs;

  multiPkgs =
    let
      xorgDeps = pkgs: with pkgs.xorg; [
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
    in
    pkgs: with pkgs; [
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
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
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
    ] ++ xorgDeps pkgs
    ++ extraLibraries pkgs;

  profile = ''
    export GST_PLUGIN_PATH=/usr/lib32/gstreamer-1.0:/usr/lib64/gstreamer-1.0
  '';
};
in
symlinkJoin {
  name = "bottles";
  paths = [
    (buildFHSUserEnvBubblewrap (fhsEnv // { name = "bottles"; runScript = "bottles"; }))
    (buildFHSUserEnvBubblewrap (fhsEnv // { name = "bottles-cli"; runScript = "bottles-cli"; }))
  ];
  postBuild = ''
    mkdir -p $out/share
    ln -s ${bottles-unwrapped}/share/applications $out/share
    ln -s ${bottles-unwrapped}/share/icons $out/share
  '';

  inherit (bottles-unwrapped) meta;
}
