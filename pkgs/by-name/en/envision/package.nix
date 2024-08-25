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

          # Additional dependencies required for Monado WMR support
          bc
          fmt
          fmt.dev
          git-lfs
          gtest
          jq
          libepoxy
          lz4.dev
          tbb
          libxkbcommon

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
    )
    ++ (
      # SteamVR driver dependencies
      [ pkgs.zlib ])
    ++ (
      # WiVRn dependencies
      pkgs.wivrn.buildInputs
      ++ pkgs.wivrn.nativeBuildInputs
      ++ (with pkgs; [
        glib
        avahi
        cmake
        cli11
        ffmpeg
        git
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        libmd
        ninja
        nlohmann_json
        openxr-loader
        pipewire
        systemdLibs # udev
        vulkan-loader
        vulkan-headers
        x264
      ])
    );
in
buildFHSEnv rec {
  name = "envision";
  inherit (envision-unwrapped) version;

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
      pkgs'.auto-patchelf
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
    ln -s ${envision-unwrapped}/share $out/share
  '';

  # Putting libgcc.lib in runtimeBuildDeps causes error "ld: cannot find crt1.o: No such file or directory"
  runScript = "env libs=${
    lib.makeLibraryPath ((runtimeBuildDeps pkgs) ++ [ pkgs.libgcc.lib ])
  } envision --skip-dependency-check";

  meta = envision-unwrapped.meta // {
    description = "${envision-unwrapped.meta.description} (with build environment)";
  };
}
