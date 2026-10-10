{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
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
  python = python3Packages.python.override {
    self = python;
    packageOverrides = self: super: {
      paho-mqtt = self.paho-mqtt_1;
    };
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "esphome";
  version = "2026.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "esphome";
    tag = finalAttrs.version;
    hash = "sha256-EqjmwBppfxh5+2edF94ZzptQveVekehZ6dBDj96Ddeg=";
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
      --replace-fail "setuptools==84.0.0" "setuptools" \
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
    "--prefix PATH : ${
      lib.makeBinPath [
        platformio
        esptool
        git
      ]
    }"
    # The dashboard requires esphome to be importable
    # dependencies are added to show better error messages
    "--prefix PYTHONPATH : $out/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc ]}"
    "--set ESPHOME_USE_SUBPROCESS ''"
    # https://github.com/NixOS/nixpkgs/issues/362193
    "--set PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION 'python'"
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

  disabledTestPaths = [
    # platformio builds; requires networking for dependency resolution
    "tests/integration"

    # tries to dynamically patch platformio module
    "tests/unit_tests/test_writer.py"
    "tests/unit_tests/test_espidf_component.py"
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

  disabledTests = [
    # tries to import platformio, which is wrapped in an fhsenv
    "test_clean_build"
    "test_clean_build_empty_cache_dir"
    "test_clean_all"
    "test_clean_all_partial_exists"
    "test_get_platformio_config_returns_project_config"
    "test_resolve_registry_version_raises_without_pkg_file"
    # tries to use esptool, which is wrapped in an fhsenv
    "test_upload_using_esptool_passes_crystal_callback"
    "test_upload_using_esptool_path_conversion"
    "test_upload_using_esptool_skips_missing_extra_flash_images"
    "test_upload_using_esptool_with_file_path"
    # AssertionError: Expected 'run_external_command' to have been called once. Called 0 times.
    "test_run_platformio_cli_sets_environment_variables"
    # Expects a full git clone
    "test_clang_tidy_mode_full_scan"
    "test_clang_tidy_mode_targeted_scan"
    # Patched to run platformio without the esphome wrapper
    "test_run_platformio_cli_strips_win_long_path_prefix"
    "test_run_platformio_cli_does_not_set_pythonexepath_without_strip"
    "test_patch_file_downloader_recovers_against_real_server"
    # 20261010: tests fail due to `AttributeError: 'NoneType' object has no attribute 'items'`
    #  attempts to download a remote asset from github
    "test_dynamic_widget_creates_correctly"
    "test_dynamic_widget_type_use_define_is_registered"
    "test_dynamic_widget_style_use_defines_are_registered"
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
      tmarkus
    ];
    mainProgram = "esphome";
  };
})
