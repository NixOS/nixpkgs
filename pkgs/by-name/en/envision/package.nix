{ buildFHSEnv, envision-unwrapped }:

buildFHSEnv {
  name = "envision";

  extraOutputsToInstall = [ "dev" ];

  strictDeps = true;

  targetPkgs =
    pkgs:
    [ pkgs.envision-unwrapped ]
    ++ (with pkgs; [
      glibc
      gcc
    ])
    ++ (
      # OpenHMD dependencies
      pkgs.openhmd.buildInputs ++ pkgs.openhmd.nativeBuildInputs
    )
    ++ (
      # OpenComposite dependencies
      pkgs.opencomposite.buildInputs ++ pkgs.opencomposite.nativeBuildInputs ++ [ pkgs.boost ]
    )
    ++ (
      # Monado dependencies
      (
        pkgs.monado.buildInputs
        ++ pkgs.monado.nativeBuildInputs
        ++ (with pkgs; [
          # Additional dependencies required by Monado when built using Envision
          mesa
          shaderc
          xorg.libX11
          xorg.libxcb
          xorg.libXrandr
          xorg.libXrender
          xorg.xorgproto
        ])
      )
    )
    ++ (
      # SteamVR driver dependencies
      [ pkgs.zlib ])
    ++ (
      # WiVRn dependencies
      # TODO: Replace with https://github.com/NixOS/nixpkgs/pull/316975 once merged
      (with pkgs; [
        avahi
        cmake
        cli11
        ffmpeg
        git
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        libmd
        libdrm
        libpulseaudio
        libva
        ninja
        nlohmann_json
        openxr-loader
        pipewire
        systemdLibs # udev
        vulkan-loader
        vulkan-headers
        x264
      ])
      ++ (with pkgs; [
        android-tools # For adb installing WiVRn APKs
      ])
    );

  profile = ''
    export CMAKE_LIBRARY_PATH=/usr/lib
    export CMAKE_INCLUDE_PATH=/usr/include
    export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig
  '';

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/metainfo
    ln -s ${envision-unwrapped}/share/envision $out/share
    ln -s ${envision-unwrapped}/share/icons $out/share
    ln -s ${envision-unwrapped}/share/applications/org.gabmus.envision.desktop $out/share/applications
    ln -s ${envision-unwrapped}/share/metainfo/org.gabmus.envision.appdata.xml $out/share/metainfo
  '';

  runScript = "envision";

  meta = envision-unwrapped.meta // {
    description = "${envision-unwrapped.meta.description} (with build environment)";
  };
}
