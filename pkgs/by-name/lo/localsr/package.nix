{
  lib,
  stdenv,
  aws-lc,
  cacert,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  ps,
  wrapGAppsHook3,
  makeBinaryWrapper,
  glib-networking,
  webkitgtk_4_1,
  python3,
  runCommand,
  sqlite,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

let
  # Inference engine the desktop host starts as its worker process
  engine = python3.pkgs.buildPythonPackage {
    pname = "localsr";
    inherit (localsr) version src;
    pyproject = true;

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail '"setuptools>=84.1.0"' '"setuptools"'
    '';

    build-system = with python3.pkgs; [ setuptools ];

    # NumPy 1.x is only needed by the Intel macOS PyTorch wheels
    pythonRelaxDeps = [ "numpy" ];

    # Core ML acceleration on Apple silicon, without which the engine uses MPS
    pythonRemoveDeps = [
      "coremltools"
      "pyobjc-framework-CoreML"
    ];

    dependencies = with python3.pkgs; [
      av
      numpy
      pillow
      psutil
      rawpy
      spandrel
      tifffile
      torch
      torchvision
    ];

    pythonImportsCheck = [ "localsr.worker.cli" ];

    nativeCheckInputs = [
      ps
      writableTmpDirAsHomeHook
    ]
    ++ (with python3.pkgs; [
      hypothesis
      pytest-timeout
      pytestCheckHook
    ]);

    # Tests serve files on localhost
    __darwinAllowLocalNetworking = true;

    disabledTestPaths = [
      # Requires onnx
      "tests/test_onnx_runtime.py"
      # Starts the engine with PYTHONPATH replaced, which hides its dependencies
      "tests/test_worker_hostile_input.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Video export crashes intermittently with SIGTRAP in the sandbox
      "tests/test_video_*.py"
    ];

    disabledTests = [
      # Start Python with PYTHONPATH replaced, which hides the dependencies
      "test_a_terminated_worker_takes_the_program_along"
      "test_a_worker_that_exits_takes_the_program_along"
      "test_cli_help_needs_neither_gui_toolkit"
      "test_importing_the_seedvr2_engine_keeps_the_vendored_optimisation_report_off_stdout"
      "test_killing_the_workers_process_group_reaches_the_program"
      "test_the_engine_answers_a_capabilities_request_with_its_hardware"
      "test_the_program_shares_the_workers_process_group"
      "test_the_system_codec_helper_does_not_outlive_the_worker_either"
      # Pretend to run on Windows, which breaks shutil.which
      "test_capability_report_does_not_advertise_unimplemented_qnn"
      "test_directml_driver_failure_preserves_cpu_capabilities"
      # Requires coremltools
      "test_conversion_does_not_load_the_program_it_has_just_made"
      # Runs the release build script, which requires npm
      "test_engine_library_links_are_removed_when_the_linuxdeploy_wrapper_cannot_be_set_up"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # sips cannot write HEIC images in the sandbox
      "test_a_heic_export_previews"
      "test_heic_decodes_through_macos_without_a_spurious_alpha_channel"
      "test_heic_export_keeps_transparency"
      "test_heic_export_preserves_colour_metadata_and_quality"
      "test_regions_cut_from_a_heic_export"
      # The sandbox keeps the process out of the background priority band
      "test_set_low_priority_updates_self_and_running_children"
    ];

    meta = {
      description = "Inference engine of LocalSR";
      inherit (localsr.meta)
        homepage
        changelog
        maintainers
        platforms
        ;
      license = with lib.licenses; [
        mit
        asl20
      ];
    };
  };

  worker = python3.withPackages (_: [ engine ]);

  # Tauri resource directory, where the host looks for its engine
  resources =
    if stdenv.hostPlatform.isDarwin then
      "Applications/LocalSR.app/Contents/Resources"
    else
      "lib/LocalSR";

  localsr = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "localsr";
    version = "0.5.0-beta";

    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "HerRei";
      repo = "local-upscale";
      tag = "v${finalAttrs.version}";
      hash = "sha256-CcKYrGN6F5dJSEdZxZ3RpTkt/9922Vqeu/lFG2mcYYU=";
    };

    npmDeps = fetchNpmDeps {
      inherit (finalAttrs) src;
      sourceRoot = "${finalAttrs.src.name}/desktop";
      hash = "sha256-5xMeafZNqM9Rm4LaXrolslb9+A07nl0Aq4A2mGfCb9Q=";
    };

    npmRoot = "desktop";
    cargoRoot = "desktop/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;
    cargoHash = "sha256-lv2Gf8v3GRuakkpJ175D3PjadU0qhIX8fh9Rs2OAqZc=";

    nativeBuildInputs = [
      cargo-tauri.hook
      nodejs
      npmHooks.npmConfigHook
      makeBinaryWrapper
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ];

    buildInputs = [
      aws-lc
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_1
    ];

    nativeCheckInputs = [
      cacert
      ps
    ];

    checkFlags = [
      # Local update feeds are only accepted by debug builds
      "--skip=updates::tests::a_planted_partial_link_never_redirects_a_download_or_a_join"
      "--skip=updates::tests::a_split_package_downloads_its_parts_and_is_reused_once_joined"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # ps does not report the helper processes in the sandbox
      "--skip=process_tree::tests::noticing_the_exit_of_the_leader_ends_what_it_left_behind"
      "--skip=process_tree::tests::terminating_the_tree_ends_the_helpers_the_child_started"
      "--skip=process_tree::tests::what_a_finished_leader_left_behind_is_ended_before_it_is_reaped"
      # The sandbox keeps the process out of the background priority band
      "--skip=process_priority::tests::macos_apply_to_pid_lowers_and_restores_child_priority"
    ];

    tauriBuildFlags = [
      "--config"
      (builtins.toJSON { bundle.category = "Photography"; })
    ];

    # Tests serve files on localhost
    __darwinAllowLocalNetworking = true;

    postInstall = ''
      makeBinaryWrapper ${lib.getExe worker} "$out/${resources}/engine/localsr-worker" \
        --add-flags "-u -m localsr.worker"
    '';

    passthru = {
      inherit engine;
      tests.worker =
        runCommand "localsr-worker-test"
          {
            nativeBuildInputs = [
              python3
              writableTmpDirAsHomeHook
            ];
          }
          ''
            python3 ${finalAttrs.src}/packaging/smoke_worker.py ${finalAttrs.finalPackage}/${resources}/engine/localsr-worker
            touch "$out"
          '';
      # Upstream only publishes beta releases
      updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };
    };

    meta = {
      description = "Desktop app for offline AI image and video upscaling, denoising and restoration";
      homepage = "https://github.com/HerRei/local-upscale";
      changelog = "https://github.com/HerRei/local-upscale/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = with lib.licenses; [
        mit
        # Vendored SeedVR2 code and embeddings
        asl20
        # Bundled IBM Plex Sans font
        ofl
      ];
      mainProgram = "localsr-next";
      maintainers = with lib.maintainers; [ yiyu ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  });
in
localsr
