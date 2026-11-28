{
  lib,
  stdenv,
  buildFHSEnv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
  bashNonInteractive,
  platformio,
  platformio-core,
  esptool,
  git,
  versionCheckHook,
  addBinToPathHook,
  writableTmpDirAsHomeHook,
  nixosTests,
}:

let
  python = python3Packages.python;

  # The toolchains ESPHome downloads (ESP-IDF, and its own Arduino toolchain
  # for ESP8266) are built for generic Linux and use the FHS dynamic loader
  # path, so on Linux the CLI runs in an FHS env, like arduino-cli.
  wrapInFHSEnv =
    unwrapped:
    buildFHSEnv {
      inherit (unwrapped) pname version meta;

      runScript = lib.getExe unwrapped;

      targetPkgs =
        pkgs: with pkgs; [
          zlib
          zstd
          ncurses
          libusb1
          udev
        ];

      extraInstallCommands = ''
        ln -s ${unwrapped}/share $out/share
      '';

      passthru = {
        inherit unwrapped;
        inherit (unwrapped) src tests;
      };
    };

  buildEsphome =
    attrs:
    let
      unwrapped = python3Packages.buildPythonApplication attrs;
    in
    if stdenv.hostPlatform.isLinux then wrapInFHSEnv unwrapped else unwrapped;
in
buildEsphome (finalAttrs: {
  pname = "esphome";
  version = "2026.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome";
    tag = finalAttrs.version;
    hash = "sha256-JY7USkJL/+3yd+EE9atCgldrEFox8EZfDTrpKQ3X19w=";
  };

  patches = [
    # Use the esptool executable directly in the ESP32 post build script, that
    # gets executed by platformio. This is required, because platformio uses its
    # own python environment through `python -m esptool` and then fails to find
    # the esptool library.
    ./esp32-post-build-esptool-reference.patch
    # Call the platformio binary directly instead of `python -m
    # esphome.platformio_runner`, which tries to import platformio as a Python
    # module.
    ./platformio-binary-reference.patch
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    "esptool"
    "platformio"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==84.2.1" "setuptools" \
      --replace-fail "wheel>=0.43,<0.49" "wheel"
  '';

  # Remove esptool and platformio from requirements
  env.ESPHOME_USE_SUBPROCESS = "";

  dependencies = with python.pkgs; [
    aioesphomeapi
    argcomplete
    bleak
    click
    colorama
    cryptography
    esphome-glyphsets
    filelock
    freetype-py
    jinja2
    ninja
    paho-mqtt
    pillow
    platformdirs
    (toPythonModule (platformio-core.override { python3 = python; }))
    puremagic
    py7zr
    pyparsing
    pyserial
    pyyaml
    requests
    resvg-py
    ruamel-yaml
    ruamel-yaml-clib
    smpclient
    tzdata
    tzlocal
    voluptuous
    zeroconf
  ];

  makeWrapperArgs = [
    # platformio is used in esphome/platformio_api.py
    # esptool is used in esphome/__main__.py
    # git is used in esphome/git.py
    # sh is used by ninja, which nixpkgs patches to look up in PATH (see https://github.com/NixOS/nixpkgs/pull/432064)
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      platformio
      esptool
      git
      bashNonInteractive
    ])

    # The dashboard requires esphome to be importable
    # dependencies are added to show better error messages
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}"

    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ stdenv.cc.cc ])

    "--set"
    "ESPHOME_USE_SUBPROCESS"
    ""

    # https://github.com/NixOS/nixpkgs/issues/362193
    "--set"
    "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION"
    "python"
  ];

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs =
    with python.pkgs;
    [
      (python3Packages.toPythonModule esptool)
      hypothesis
      mock
      pytest-asyncio
      pytest-cov-stub
      pytest-mock
      pytestCheckHook
      ruff
    ]
    ++ [
      git
      versionCheckHook
      addBinToPathHook
      writableTmpDirAsHomeHook
    ];

  postInstall =
    let
      argcomplete = lib.getExe' python.pkgs.argcomplete "register-python-argcomplete";
    in
    ''
      installShellCompletion --cmd esphome \
        --bash <(${argcomplete} --shell bash esphome) \
        --zsh <(${argcomplete} --shell zsh esphome) \
        --fish <(${argcomplete} --shell fish esphome)
    '';

  disabledTestPaths = [
    # tries to use esptool, which is wrapped in an fhsenv
    "tests/unit_tests/test_main.py::test_upload_using_esptool_passes_crystal_callback"
    "tests/unit_tests/test_main.py::test_upload_using_esptool_path_conversion"
    "tests/unit_tests/test_main.py::test_upload_using_esptool_skips_missing_extra_flash_images"
    "tests/unit_tests/test_main.py::test_upload_using_esptool_with_file_path"
    # Patched to run platformio without the esphome wrapper
    "tests/unit_tests/test_platformio_toolchain.py::test_run_platformio_cli_does_not_set_pythonexepath_without_strip"
    "tests/unit_tests/test_platformio_toolchain.py::test_run_platformio_cli_sets_environment_variables"
    "tests/unit_tests/test_platformio_toolchain.py::test_run_platformio_cli_strips_win_long_path_prefix"
    #  attempts to download a remote asset from github
    "tests/component_tests/lvgl/test_list_outside_block.py::test_dynamic_widget_creates_correctly"
    "tests/component_tests/lvgl/test_list_outside_block.py::test_dynamic_widget_type_use_define_is_registered"
    "tests/component_tests/lvgl/test_list_outside_block.py::test_dynamic_widget_style_use_defines_are_registered"
    # platformio builds; requires networking for dependency resolution
    "tests/integration"
    # tries to dynamically patch platformio module
    "tests/unit_tests/test_writer.py"
    "tests/unit_tests/test_espidf_component.py"
    # depends on yamlrocks, which is not packaged in nixpkgs
    "tests/script/test_sync_dependency_versions.py"
    # expects PYTHONPATH to be set up in a very specific way
    "tests/unit_tests/test_espidf_framework.py::test_install_tool_archives_extracts_pending_in_parallel"
    # wants to access /dev/ttyUSB0
    "tests/unit_tests/test_main.py::test_upload_using_esptool_arduino_toolchain"
    # we are not always on apple silicon
    "tests/unit_tests/test_platformio_pch_script.py::test_pch_script_gcc10_wrapper_on_apple_silicon"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: No username set in the environment
    "tests/unit_tests/test_main.py::test_check_permissions_unreadable_port"
  ];

  passthru = {
    tests = { inherit (nixosTests) esphome; };
  };

  meta = {
    changelog = "https://github.com/esphome/esphome/releases/tag/${finalAttrs.src.tag}";
    description = "Make creating custom firmwares for ESP32/ESP8266 super easy";
    homepage = "https://esphome.io/";
    license = with lib.licenses; [
      mit # The C++/runtime codebase of the ESPHome project (file extensions .c, .cpp, .h, .hpp, .tcc, .ino)
      gpl3Only # The python codebase and all other parts of this codebase
    ];
    maintainers = with lib.maintainers; [
      picnoir
      thanegill
      karlbeecken
      AAAAAASomeThingsFailToEvaluate
    ];
    mainProgram = "esphome";
  };
})
