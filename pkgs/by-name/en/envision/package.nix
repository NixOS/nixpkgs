{
  lib,
  buildFHSEnv,
  envision-unwrapped,
  envision,
  testers,
}:

buildFHSEnv {
  pname = "envision";
  inherit (envision-unwrapped) version;

  extraOutputsToInstall = [ "dev" ];

  strictDeps = true;

  # TODO: I'm pretty suspicious of this list of additional required dependencies. Are they all really needed?
  targetPkgs =
    pkgs:
    [ pkgs.envision-unwrapped ]
    ++ (with pkgs; [
      stdenv.cc.libc
      gcc
    ])
    ++
      # OpenHMD dependencies
      (
        pkgs.openhmd.buildInputs
        ++ pkgs.openhmd.nativeBuildInputs
        ++ (with pkgs; [
          meson
        ])
      )

    ++ (
      # OpenComposite dependencies
      pkgs.opencomposite.buildInputs ++ pkgs.opencomposite.nativeBuildInputs
    )
    ++
      # Monado dependencies
      (
        pkgs.monado.buildInputs
        ++ pkgs.monado.nativeBuildInputs
        ++ (with pkgs; [
          # Additional dependencies required by Monado when built using Envision
          libgbm
          shaderc
          xorg.libX11
          xorg.libxcb
          xorg.libXrandr
          xorg.libXrender
          xorg.xorgproto
          SDL2
          wayland
          mesa-gl-headers
          # Additional dependencies required for Monado WMR support
          bc
          fmt
          fmt.dev
          git-lfs
          gtest
          jq
          libepoxy
          lz4
          lz4.dev
          onetbb
          libxkbcommon
          librealsense
          boost
          glew
        ])
      )

    ++
      # SteamVR driver dependencies
      [ pkgs.zlib ]
    ++ (
      # WiVRn dependencies
      pkgs.wivrn.buildInputs
      ++ pkgs.wivrn.nativeBuildInputs
      ++ (with pkgs; [
        avahi
        ffmpeg
        glib
        libmd
        ninja
        glslang
        gst_all_1.gstreamer
        gdk-pixbuf
        lerc
        libsysprof-capture
        libbsd
        libdeflate
        libdrm
        libGL
        libnotify
        libpng
        libselinux
        libsepol
        libtiff
        libuuid
        libwebp
        openssl
        openxr-loader
        pipewire
        pulseaudio
        systemd
        vulkan-loader
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
    ln -s ${envision-unwrapped}/share $out/share
  '';

  runScript = "envision";

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
        script = ''
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
