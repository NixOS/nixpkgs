{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  git,
  spdx-license-list-data,
  replaceVars,
  writableTmpDirAsHomeHook,
  udevCheckHook,
}:

with python3Packages;
buildPythonApplication rec {
  pname = "platformio";
  version = "6.1.18";
  pyproject = true;

  # pypi tarballs don't contain tests - https://github.com/platformio/platformio-core/issues/1964
  src = fetchFromGitHub {
    owner = "platformio";
    repo = "platformio-core";
    tag = "v${version}";
    hash = "sha256-h9/xDWXCoGHQ9r2f/ZzAtwTAs4qzDrvVAQ2kuLS9Lk8=";
  };

  outputs = [
    "out"
    "udev"
  ];

  patches = [
    (replaceVars ./interpreter.patch {
      interpreter = (python3Packages.python.withPackages (_: dependencies)).interpreter;
    })
    (replaceVars ./use-local-spdx-license-list.patch {
      spdx_license_list_data = spdx-license-list-data.json;
    })
    ./missing-udev-rules-nixos.patch
    (fetchpatch {
      # restore PYTHONPATH when calling scons
      # https://github.com/platformio/platformio-core/commit/097de2be98af533578671baa903a3ae825d90b94
      url = "https://github.com/platformio/platformio-core/commit/097de2be98af533578671baa903a3ae825d90b94.patch";
      hash = "sha256-yq+/QHCkhAkFND11MbKFiiWT3oF1cHhgWj5JkYjwuY0=";
      revert = true;
    })
    ./builder-prioritize-python-env-in-path.patch
  ];

  postPatch = ''
    # Disable update checks at runtime
    substituteInPlace platformio/maintenance.py --replace-fail '    check_platformio_upgrade()' ""

    # Remove filterwarnings which fails on new deprecations in Python 3.12 for 3.14
    rm tox.ini
  '';

  nativeBuildInputs = [
    installShellFiles
    udevCheckHook
  ];

  build-system = [ setuptools ];

  pythonRelaxDeps = true;

  dependencies = [
    aiofiles
    ajsonrpc
    bottle
    click
    click-completion
    colorama
    esp-idf-size
    git
    intelhex
    lockfile
    marshmallow
    pip
    pyelftools
    pyparsing
    pyserial
    pyyaml
    requests
    rich-click
    semantic-version
    setuptools
    spdx-license-list-data.json
    starlette
    tabulate
    uvicorn
    wheel
    wsproto
    zeroconf
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    chardet
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin
  '';

  nativeCheckInputs = [
    jsondiff
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Install udev rules into a separate output so all of platformio-core is not a dependency if
  # you want to use the udev rules on NixOS but not install platformio in your system packages.
  postInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    cp platformio/assets/system/99-platformio-udev.rules $udev/lib/udev/rules.d/99-platformio-udev.rules

    installShellCompletion --cmd platformio \
      --bash <(_PLATFORMIO_COMPLETE=bash_source $out/bin/platformio) \
      --zsh <(_PLATFORMIO_COMPLETE=zsh_source $out/bin/platformio) \
      --fish <(_PLATFORMIO_COMPLETE=fish_source $out/bin/platformio)

    installShellCompletion --cmd pio \
      --bash <(_PIO_COMPLETE=bash_source $out/bin/pio) \
      --zsh <(_PIO_COMPLETE=zsh_source $out/bin/pio) \
      --fish <(_PIO_COMPLETE=fish_source $out/bin/pio)
  '';

  enabledTestPaths = [
    "tests"
  ];

  disabledTestPaths = [
    "tests/commands/pkg/test_install.py"
    "tests/commands/pkg/test_list.py"
    "tests/commands/pkg/test_outdated.py"
    "tests/commands/pkg/test_search.py"
    "tests/commands/pkg/test_show.py"
    "tests/commands/pkg/test_uninstall.py"
    "tests/commands/pkg/test_update.py"
    "tests/commands/test_boards.py"
    "tests/commands/test_check.py"
    "tests/commands/test_platform.py"
    "tests/commands/test_run.py"
    "tests/commands/test_test.py"
    "tests/misc/test_maintenance.py"

    # requires internet connection
    "tests/misc/ino2cpp/test_ino2cpp.py"

    "tests/commands/pkg/test_exec.py::test_pkg_specified"
    "tests/commands/pkg/test_exec.py::test_unrecognized_options"
    "tests/commands/test_ci.py::test_ci_boards"
    "tests/commands/test_ci.py::test_ci_build_dir"
    "tests/commands/test_ci.py::test_ci_keep_build_dir"
    "tests/commands/test_ci.py::test_ci_lib_and_board"
    "tests/commands/test_ci.py::test_ci_project_conf"
    "tests/commands/test_init.py::test_init_custom_framework"
    "tests/commands/test_init.py::test_init_duplicated_boards"
    "tests/commands/test_init.py::test_init_enable_auto_uploading"
    "tests/commands/test_init.py::test_init_ide_atom"
    "tests/commands/test_init.py::test_init_ide_clion"
    "tests/commands/test_init.py::test_init_ide_eclipse"
    "tests/commands/test_init.py::test_init_ide_vscode"
    "tests/commands/test_init.py::test_init_incorrect_board"
    "tests/commands/test_init.py::test_init_special_board"
    "tests/commands/test_lib.py::test_global_install_archive"
    "tests/commands/test_lib.py::test_global_install_registry"
    "tests/commands/test_lib.py::test_global_install_repository"
    "tests/commands/test_lib.py::test_global_lib_list"
    "tests/commands/test_lib.py::test_global_lib_uninstall"
    "tests/commands/test_lib.py::test_global_lib_update"
    "tests/commands/test_lib.py::test_global_lib_update_check"
    "tests/commands/test_lib.py::test_install_duplicates"
    "tests/commands/test_lib.py::test_lib_show"
    "tests/commands/test_lib.py::test_lib_stats"
    "tests/commands/test_lib.py::test_saving_deps"
    "tests/commands/test_lib.py::test_search"
    "tests/commands/test_lib.py::test_update"
    "tests/commands/test_lib_complex.py::test_global_install_archive"
    "tests/commands/test_lib_complex.py::test_global_install_registry"
    "tests/commands/test_lib_complex.py::test_global_install_repository"
    "tests/commands/test_lib_complex.py::test_global_lib_list"
    "tests/commands/test_lib_complex.py::test_global_lib_uninstall"
    "tests/commands/test_lib_complex.py::test_global_lib_update"
    "tests/commands/test_lib_complex.py::test_global_lib_update_check"
    "tests/commands/test_lib_complex.py::test_install_duplicates"
    "tests/commands/test_lib_complex.py::test_lib_show"
    "tests/commands/test_lib_complex.py::test_lib_stats"
    "tests/commands/test_lib_complex.py::test_search"
    "tests/package/test_manager.py::test_download"
    "tests/package/test_manager.py::test_install_force"
    "tests/package/test_manager.py::test_install_from_registry"
    "tests/package/test_manager.py::test_install_lib_depndencies"
    "tests/package/test_manager.py::test_registry"
    "tests/package/test_manager.py::test_uninstall"
    "tests/package/test_manager.py::test_update_with_metadata"
    "tests/package/test_manager.py::test_update_without_metadata"
    "tests/test_builder.py::test_build_flags"
    "tests/test_builder.py::test_build_unflags"
    "tests/test_builder.py::test_debug_custom_build_flags"
    "tests/test_builder.py::test_debug_default_build_flags"
    "tests/test_misc.py::test_api_cache"
    "tests/test_misc.py::test_ping_internet_ips"
    "tests/test_misc.py::test_platformio_cli"
    "tests/test_pkgmanifest.py::test_packages"
  ];

  disabledTests = [
    # requires internet connection
    "test_api_cache"
    "test_ping_internet_ips"
    "test_metadata_dump"
  ];

  passthru = {
    python = python3Packages.python;
  };

  meta = with lib; {
    changelog = "https://github.com/platformio/platformio-core/releases/tag/${src.tag}";
    description = "Open source ecosystem for IoT development";
    downloadPage = "https://github.com/platformio/platformio-core";
    homepage = "https://platformio.org";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mog
      makefu
    ];
    mainProgram = "platformio";
  };
}
