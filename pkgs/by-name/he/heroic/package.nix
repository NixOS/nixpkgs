{
  lib,
  steam,
  heroic-unwrapped,

  # Extra flags passed to Heroic/Electron, e.g. "--enable-features=VaapiVideoDecoder"
  commandLineArgs ? "",
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraEnv ? { },
  extraProfile ? "",
  extraPreBwrapCmds ? "",
  extraBwrapArgs ? [ ],
}:

steam.buildRuntimeEnv {
  pname = "heroic";
  inherit (heroic-unwrapped) version meta;

  runScript = "heroic ${commandLineArgs}";

  extraPkgs =
    pkgs:
    [
      heroic-unwrapped
      pkgs.cabextract
      pkgs.curl
      pkgs.rsync
      pkgs.unzip
      # winetricks and heroic look for `7z`
      (pkgs.runCommand "7zz-compat" { } ''
        mkdir -p $out/bin
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7z
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7za
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7zz
      '')
    ]
    ++ extraPkgs pkgs;

  extraLibraries =
    pkgs:
    with pkgs;
    [
      alsa-lib
      cups
      dbus
      fontconfig
      freetype
      gnutls
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      libgphoto2
      libkrb5
      libpcap
      libpulseaudio
      libusb1
      libv4l
      libxkbcommon
      libx11
      libxcomposite
      libxcursor
      libxext
      libxfixes
      libxi
      libxinerama
      libxrandr
      libxrender
      ocl-icd
      SDL2
      sane-backends
      unixodbc
      wayland
    ]
    ++ extraLibraries pkgs;

  inherit
    extraEnv
    extraProfile
    extraPreBwrapCmds
    extraBwrapArgs
    ;

  privateTmp = false;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${heroic-unwrapped}/share/applications $out/share
    ln -s ${heroic-unwrapped}/share/icons $out/share
  '';
}
