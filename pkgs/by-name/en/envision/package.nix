{
  lib,
  pkgs,
  buildFHSEnv,
  envision,
  envision-unwrapped,
  testers,
}:

let
  runtimeBuildDeps =
    pkgs':
    with pkgs';
    (
      (
        # OpenHMD dependencies
        (
          pkgs.openhmd.buildInputs
          ++ pkgs.openhmd.nativeBuildInputs
          ++ (with pkgs; [
            meson
          ])
        )
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
          SDL2
          wayland

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
          boost
          glew

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
        glslang
        libdrm
        openssl
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

  # TODO: When buildFHSEnv gets finalAttrs support, profiles should be moved into the derivation so it can be overrideAttrs'd
  passthru.tests =
    let
      kebabToPascal =
        kebab:
        lib.foldl' (
          acc: part: acc + lib.substring 0 1 (lib.toUpper part) + lib.substring 1 (lib.stringLength part) part
        ) "" (lib.splitString "-" kebab);
      pascalToCamel =
        pascal: lib.substring 0 1 (lib.toLower pascal) + lib.substring 1 (lib.stringLength pascal) pascal;
      kebabToCamel = x: pascalToCamel (kebabToPascal x);
      profiles = [
        "lighthouse-default"
        "openhmd-default"
        "simulated-default"
        "survive-default"
        "wmr-default"
        "wivrn-default"
      ];
    in
    {
      allProfilesPresent = testers.runCommand {
        name = "envision-all-profiles-present-test";
        # TODO: Is there a better way to escape ${}?
        script =
          ''
            export ALL_PROFILES=(${lib.concatStringsSep " " (profiles ++ [ "UUID" ])})
            export ENVISION_PROFILES=($(envision -l | grep -oP '^\w+(?=:)'))

            # This is dark magic
            missing_from_array=($(grep -vf <(printf "%s\n" "$''
          + ''{ALL_PROFILES[@]}") <(printf "%s\n" "$''
          + ''
            {ENVISION_PROFILES[@]}") || true))

                      if [ $''
          + ''
            {#missing_from_array[@]} -gt 0 ]; then
                        echo "Missing profiles: $''
          + ''
            {missing_from_array[@]}"
                        exit 1
                      fi

                      touch $out
          '';
        nativeBuildInputs = [ envision ];
      };
    }
    // lib.listToAttrs (
      lib.map (profile: {
        name = "${kebabToCamel profile}DependenciesMet";
        value = testers.runCommand {
          name = "envision-profile-${profile}-dependencies-met-test";
          script = ''
            envision -c ${profile}
            touch $out
          '';
          nativeBuildInputs = [ envision ];
        };
      }) profiles
    );

  meta = envision-unwrapped.meta // {
    description = "${envision-unwrapped.meta.description} (with build environment)";
  };
}
