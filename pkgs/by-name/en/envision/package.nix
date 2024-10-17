{
  lib,
  pkgs,
  buildFHSEnv,
  envision-unwrapped,
}:

let
  runtimeBuildDeps =
    pkgs':
    with pkgs';
    (
      (
        # OpenHMD dependencies
        openhmd.buildInputs ++ openhmd.nativeBuildInputs
      )
      ++ (
        # OpenComposite dependencies
        opencomposite.buildInputs ++ opencomposite.nativeBuildInputs ++ [ boost ]
      )
      ++ (
        # Monado dependencies
        monado.buildInputs
        ++ monado.nativeBuildInputs
        ++ [
          # Additional dependencies required by Monado when built using Envision
          mesa # TODO: Does this really need "mesa-common-dev"?
          xorg.libX11
          xorg.libxcb
          xorg.libXrandr
          xorg.libXrender
          xorg.xorgproto

          # Not required for build, but autopatchelf requires them
          glibc
          SDL2
          bluez
          librealsense
          onnxruntime
          libusb1
          libjpeg
          libGL
        ]
      )
      ++ [
        # SteamVR dependencies
        zlib
      ]
      ++ [
        # WiVRn dependencies
        # TODO: Replace with https://github.com/NixOS/nixpkgs/pull/316975 once merged
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
      ]
    );
in
buildFHSEnv rec {
  name = "envision";

  extraOutputsToInstall = [
    "dev"
    "lib"
  ];

  strictDeps = true;

  targetPkgs =
    pkgs':
    [
      (pkgs'.envision-unwrapped.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [ ./autopatchelf.patch ]; # Adds an envision build step to run autopatchelf
      }))
      pkgs'.autopatchelf
      pkgs'.gcc
      pkgs'.android-tools # For adb installing WiVRn APKs
    ]
    ++ (runtimeBuildDeps pkgs');

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

  # Putting libgcc.lib in runtimeBuildDeps causes error "ld: cannot find crt1.o: No such file or directory"
  runScript = "env libs=${
    lib.makeLibraryPath ((runtimeBuildDeps pkgs) ++ [ pkgs.libgcc.lib ])
  } envision --skip-dependency-check";

  meta = envision-unwrapped.meta // {
    description = "${envision-unwrapped.meta.description} (with build environment)";
  };
}
