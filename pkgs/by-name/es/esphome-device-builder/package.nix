{
  lib,
  callPackage,
  python3Packages,
  fetchFromGitHub,
  gitMinimal,
  versionCheckHook,
  esptool,
  esphome,
}:

let
  meta = {
    description = "ESPHome Device Builder Dashboard";
    homepage = "https://esphome.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tmarkus
      karlbeecken
    ];
    mainProgram = "esphome-device-builder";
  };

  pythonPackages = python3Packages.overrideScope (
    self: super: {
      esphome = self.toPythonModule esphome;
      esphome-device-builder-frontend = self.callPackage ./frontend.nix {
        inherit meta;
      };
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "esphome-device-builder";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder";
    tag = finalAttrs.version;
    hash = "sha256-vzHG5nsECN3qAwpDGcELf9adgGiebr99pcdDqet79s4=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = with pythonPackages; [
    pyprojectVersionPatchHook
  ];

  build-system = with pythonPackages; [
    setuptools
  ];

  dependencies = with pythonPackages; [
    esphome
    esphome-device-builder-frontend

    aiohttp
    aiohttp-asyncmdnsresolver
    colorlog
    cryptography
    fnv-hash-fast
    ifaddr
    icmplib
    mashumaro
    orjson
    pyyaml
    ruamel-yaml
    voluptuous
  ];

  nativeCheckInputs = with pythonPackages; [
    versionCheckHook
    pytestCheckHook
    pytest-aiohttp
    pytest-codspeed
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    blockbuster
  ];

  postPatch = ''
    substituteInPlace esphome_device_builder/controllers/firmware/helpers.py \
      --replace-fail 'list(_find_sibling_cli("esphome"))' '["${lib.getExe pythonPackages.esphome}"]' \
      --replace-fail 'list(_find_sibling_cli("esptool"))' '["${lib.getExe esptool}"]'

    substituteInPlace esphome_device_builder/controllers/version_history/git_repo.py \
      --replace-fail 'shutil.which("git")' '"${lib.getExe gitMinimal}"'

    substituteInPlace tests/controllers/version_history/test_git_repo.py \
      --replace-fail 'shutil.which("git")' '"${lib.getExe gitMinimal}"'
    substituteInPlace tests/test_editor_controller.py \
      --replace-fail 'controller._esphome_cmd = ["esphome"]' 'controller._esphome_cmd = ["${lib.getExe pythonPackages.esphome}"]'
  '';

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  pytestFlags = [
    "--timeout=30"
  ];

  disabledTestPaths = [
    # presumably fails due to required network access to download LibreTiny
    "tests/e2e/slow/boards/test_create_all_boards.py"
  ];

  disabledTests = [
    # tests that try to access GitHub
    "test_esp_idf_compile_download_round_trip"
    "test_libretiny_bk7231n_compile_download_round_trip"

    # timeout
    "test_get_component_bodies_returns_full_batch_larger_than_cache"

    # failed tests due to patched esphome location
    "test_find_esphome_cmd_prefers_sibling_binary_when_present"
    "test_find_esphome_cmd_falls_back_to_python_dash_m"
    "test_find_esphome_cmd_does_not_substitute_sibling_python"
    "test_find_esphome_cmd_picks_bare_esphome_on_posix"

    # failed tests due to patched git location
    "test_disabled_when_no_git"
    "test_missing_git_binary_disables_feature"

    # failed tests due to patched esptool location
    "test_find_esptool_cmd_prefers_sibling_script"
    "test_find_esptool_cmd_falls_back_to_python_dash_m"

    # TOOD: requires patching the device state monitor
    "test_start_logs_ping_count_at_debug"
  ];

  passthru = {
    frontend = pythonPackages.esphome-device-builder-frontend;
    updateScript = callPackage ./update.nix { };
  };

  meta = meta // {
    changelog = "https://github.com/esphome/device-builder/releases/tag/${finalAttrs.src.tag}";
  };
})
