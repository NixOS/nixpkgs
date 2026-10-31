{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  pkg-config,
  gz-cmake,
  gz-common,
  gz-fuel-tools,
  gz-gui,
  gz-msgs,
  gz-physics,
  gz-plugin,
  gz-rendering,
  gz-sensors,
  gz-tools,
  gz-transport,
  sdformat,
  protobuf,
  mesa,
  qt6,
  libwebsockets,
  ffmpeg,
  python3Packages,
  gtest,
  ctestCheckHook,
  runCommand,
  autoAddDriverRunpath,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    versionPrefix = "gz-sim${lib.versions.major finalAttrs.version}";
  in
  {
    pname = "gz-sim";
    version = "10.5.0";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gazebosim";
      repo = "gz-sim";
      tag = "${versionPrefix}_${finalAttrs.version}";
      hash = "sha256-Ubs1J3myDRCz6LVBtPlLb3H6jo874OuidfuN+6001hw=";
    };

    patches = [
      # The buoyancy test's baked-in duck volume predates gz-common 7.4.0's
      # Volume() fix for meshes offset from the origin; compute it from the
      # mesh instead. Merged upstream after 10.5.0:
      # https://github.com/gazebosim/gz-sim/pull/3912
      (fetchpatch2 {
        name = "compute-duck-volume-expectation.patch";
        url = "https://github.com/gazebosim/gz-sim/commit/b7b190a53f1e8451e5804fbd2a0636694370271f.patch?full_index=1";
        hash = "sha256-+5ycek1FctRqGYNF+0IB/cxHVEGdMVxmkahFbxOiFlc=";
      })
    ];

    nativeBuildInputs = [
      cmake
      pkg-config
      qt6.wrapQtAppsHook
      protobuf
      python3Packages.python
      python3Packages.pybind11
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Hardware GL/Vulkan drivers on NixOS; the Mesa defaults below cover
      # non-NixOS systems.
      autoAddDriverRunpath
    ];

    cmakeFlags = [
      # Nix sets CMAKE_INSTALL_LIBDIR to an absolute store path, which produces
      # broken doubled paths in plugin search directories.  Force it to be relative.
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
      (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "libexec")
    ];

    # Set plugin discovery paths so users don't need to export them manually.
    # --set-default allows user overrides (e.g., nixGL for hardware GL/Vulkan).
    #
    # Joined into a single string as a workaround for wrap-qt6-apps-hook: its
    # setup-hook does `qtWrapperArgs=(${qtWrapperArgs-})`, which under
    # __structuredAttrs=true sees qtWrapperArgs as a bash array and truncates
    # it to element 0.  Pre-joining into one whitespace-separated string makes
    # the re-split reproduce the full token list.  Safe because no arg value
    # contains whitespace.
    qtWrapperArgs = lib.concatStringsSep " " (
      [
        "--set-default GZ_SIM_SYSTEM_PLUGIN_PATH ${placeholder "out"}/lib/gz-sim-${lib.versions.major finalAttrs.version}/plugins"
        "--set-default GZ_SIM_PHYSICS_ENGINE_PATH ${gz-physics}/lib/gz-physics-${lib.versions.major gz-physics.version}/engine-plugins"
        "--set-default GZ_GUI_PLUGIN_PATH ${placeholder "out"}/lib/gz-sim-${lib.versions.major finalAttrs.version}/plugins/gui:${gz-gui}/lib/gz-gui-${lib.versions.major gz-gui.version}/plugins"
        "--prefix NIXPKGS_QT6_QML_IMPORT_PATH : ${placeholder "out"}/lib/gz-sim-${lib.versions.major finalAttrs.version}/plugins/gui"
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        # EGL vendor discovery for non-NixOS systems.  Mesa's EGL ICD lets
        # libglvnd find an EGL implementation for both GUI and headless
        # rendering.  --set-default means users can override (e.g. for NVIDIA).
        "--set-default __EGL_VENDOR_LIBRARY_FILENAMES ${mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
        # Vulkan ICD discovery for non-NixOS systems.  Mesa's Lavapipe is a
        # software Vulkan driver, suitable for headless and VMs without GPU
        # Vulkan.  --set-default means nixGL or the user can override for
        # hardware Vulkan (e.g. NVIDIA).
        "--set-default VK_DRIVER_FILES ${mesa}/share/vulkan/icd.d/lvp_icd.${stdenv.hostPlatform.parsed.cpu.name}.json"
      ]
    );

    postInstall = ''
      # Install a wrapped gz CLI that discovers all gz-* subcommands.
      # In Nix, each gz-* package is in its own store path, so the hardcoded
      # default in gz-tools' gz script only searches its own (empty) share/gz/.
      # GZ_CONFIG_PATH tells the script where to find *.yaml command configs.
      mkdir -p $out/bin
      makeWrapper ${gz-tools}/bin/gz $out/bin/gz \
        --set-default GZ_CONFIG_PATH ${
          lib.concatStringsSep ":" [
            "${placeholder "out"}/share/gz"
            "${gz-msgs}/share/gz"
            "${gz-transport}/share/gz"
            "${gz-gui}/share/gz"
            "${gz-plugin}/share/gz"
            "${gz-fuel-tools}/share/gz"
          ]
        }
    '';

    buildInputs = [
      gz-cmake
      libwebsockets
      ffmpeg
      # gz-sim-main links libpython at runtime for embedded Python plugin support;
      # nativeBuildInputs alone leaves it out of the rpath under strictDeps.
      python3Packages.python
    ];

    propagatedBuildInputs = [
      gz-common
      gz-fuel-tools
      gz-gui
      gz-msgs
      gz-physics
      gz-plugin
      gz-rendering
      gz-sensors
      gz-tools
      gz-transport
      sdformat
      qt6.qt5compat
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtquick3d
    ];

    nativeCheckInputs = [
      ctestCheckHook
      python3Packages.python
      python3Packages.gz-math
      python3Packages.sdformat
    ];

    checkInputs = [ gtest ];

    # gz-sim tests share a single gz-transport partition; running them in
    # parallel causes "Another world of the same name is running" errors
    # because multiple test binaries advertise the same transport topics.
    enableParallelChecking = false;

    disabledTests = [
      # Requires network access (unavailable in Nix sandbox)
      "INTEGRATION_breadcrumbs"
      "INTEGRATION_save_world"
      "INTEGRATION_spacecraft"
      "INTEGRATION_drive_to_pose_controller_system"
      "INTEGRATION_sdf_include"
      "INTEGRATION_model_photo_shoot_default_joints"
      "INTEGRATION_model_photo_shoot_random_joints"
      "INTEGRATION_model_photo_shoot_reset"
      "UNIT_SdfGenerator_TEST"
      "UNIT_Util_TEST"

      # Requires gz-sim to be installed (calls find_package during check phase)
      "INTEGRATION_examples_build"

      # Timing-sensitive under Nix build load
      "PERFORMANCE_each"
      "PERFORMANCE_ExpectData"

      # Physics precision failures
      "INTEGRATION_joint_controller_system"
      "INTEGRATION_physics_system"
      "INTEGRATION_velocity_control_system"
      "INTEGRATION_follow_actor_system"
      "INTEGRATION_touch_plugin"

      # Expects plugins NOT to be found, but GZ_SIM_SYSTEM_PLUGIN_PATH
      # (needed by other tests) exposes the build-tree plugins
      "UNIT_EntityFeatureMap_TEST"
      "UNIT_SystemLoader_TEST"
      "UNIT_SimulationRunner_TEST"

      # Test overrides GZ_SIM_SYSTEM_PLUGIN_PATH with python/test/plugins,
      # clobbering the build-tree lib/ path so all system plugins (physics,
      # user-commands, scene-broadcaster, and the loader itself) are unfindable.
      "INTEGRATION_python_system_loader"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Qt/GUI tests abort or segfault on Linux without a display server
      "UNIT_Gui_TEST"
      "UNIT_Gui_clean_exit_TEST"
      "UNIT_JointPositionController_TEST"
      "UNIT_Plot3D_TEST"
      "INTEGRATION_user_commands"
      "INTEGRATION_log_system"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # Physics precision failures on aarch64-linux (off-diagonal moments tolerance)
      "INTEGRATION_mesh_inertia_calculation"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Distributed sim handshake requires UDP multicast (IP_ADD_MEMBERSHIP),
      # which the macOS sandbox blocks (no __darwinAllowLocalNetworking)
      "INTEGRATION_network_handshake"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Physics precision failures on aarch64-darwin
      "INTEGRATION_wheel_slip"
    ];

    preCheck = ''
      # Point to the physics engine plugins (dartsim, bullet, etc.) from gz-physics
      export GZ_SIM_PHYSICS_ENGINE_PATH=${gz-physics}/lib/gz-physics-${lib.versions.major gz-physics.version}/engine-plugins
      export GZ_PHYSICS_INSTALL_PREFIX=${gz-physics}

      # Tests call getServerConfigPath() / getMediaInstallDir() which look under
      # $out, but install hasn't run yet — stage the needed files manually.
      mkdir -p $out/share/gz/gz-sim/media
      cp ${finalAttrs.src}/include/gz/sim/server.config $out/share/gz/gz-sim/
      cp ${finalAttrs.src}/include/gz/sim/playback_server.config $out/share/gz/gz-sim/
      cp ${finalAttrs.src}/src/rendering/MaterialParser/gazebo.material $out/share/gz/gz-sim/media/

      # Isolate gz-transport namespace from other concurrent builds
      export GZ_PARTITION=nixbld_$$

      # ThrustCoefficient publishes a thrust command and then runs a fixed
      # number of iterations; under build load the command arrives late and the
      # vehicle travels less than the test expects.
      export GTEST_FILTER=-ThrusterTest.ThrustCoefficient${
        # Same race: the wrench command is published just before a fixed run,
        # and on x86_64-linux it arrives after the first checked iteration.
        lib.optionalString (
          stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64
        ) ":ApplyLinkWrenchTestFixture.PersistentFromTopic"
      }

      # Let Python tests find gz-sim system plugins in the build tree
      export GZ_SIM_SYSTEM_PLUGIN_PATH=$PWD/lib

      # Python tests import gz.sim and gz.common from the pybind11 modules in
      # the build tree. gz.math and sdformat come from nativeCheckInputs; `gz`
      # is an implicit namespace package, so the portions merge.
      local pydir=$(mktemp -d)
      mkdir -p $pydir/gz
      cp lib/sim* lib/common* $pydir/gz/
      export PYTHONPATH=$pydir''${PYTHONPATH:+:$PYTHONPATH}
    '';

    doCheck = true;

    passthru = {
      tests.simulation =
        runCommand "gz-sim-smoke-test"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              writableTmpDirAsHomeHook
            ];
          }
          ''
            export GZ_PARTITION=nixtest_$$

            gz sim --headless-rendering -s -r --iterations 200 \
              ${finalAttrs.finalPackage}/share/gz/gz-sim/worlds/diff_drive.sdf
            touch $out
          '';
      updateScript = nix-update-script {
        extraArgs = [ "--version-regex=${versionPrefix}_([\\d\\.]+)" ];
      };
    };

    meta = {
      description = "Open-source robotics simulator for testing robot designs";
      homepage = "https://gazebosim.org/";
      changelog = "https://github.com/gazebosim/gz-sim/blob/${finalAttrs.src.tag}/Changelog.md";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "gz";
      maintainers = with lib.maintainers; [ taylorhoward92 ];
    };
  }
)
