{
  ccache,
  cmake,
  esp-clang,
  esp-rom-elfs,
  esp32ulp-elf,
  fetchFromGitHub,
  fetchpatch,
  jq,
  lib,
  ninja,
  openocd-esp32,
  python3Packages,
  qemu-riscv32,
  qemu-xtensa,
  riscv32-esp-elf,
  riscv32-esp-elf-gdb,
  sourceInfo ? builtins.fromJSON (builtins.readFile ./source-info.json),
  stdenv,
  xtensa-esp-elf,
  xtensa-esp-elf-gdb,
}:
stdenv.mkDerivation {
  inherit (sourceInfo) version;
  pname = "esp-idf";

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = "v${sourceInfo.version}";
    hash = "sha256-w+xyva4t21STVtfYZOXY2xw6sDc2XvJXBZSx+wd1N6Y=";
    fetchSubmodules = true;
  };

  patches = [
    # ref. https://github.com/espressif/esp-idf/pull/14402
    # but this does not apply directly on v5.3
    (fetchpatch {
      name = "remove-distutils.patch";
      url = "https://github.com/nim65s/esp-idf/commit/e61eea3916f1e04eda52929e6a6ef81508dcc1d4.patch";
      hash = "sha256-BcI/pjItdBzYy3RvQUp2LW2o1tHLEYFJhP0WGUv7FvM=";
    })
    (fetchpatch {
      name = "fix-venv-detection.patch";
      url = "https://github.com/espressif/esp-idf/pull/14435/commits/c25b563061af37df8b403c9e973ac53685ec7011.patch";
      hash = "sha256-99EVuYFYkdND0KywfIP1V30dfVltRz9RbS11UBmHrGM=";
    })
  ];

  postPatch = ''
    # Don't run pip install: we already have everything.
    # And network is not available anyways.
    substituteInPlace tools/idf_tools.py --replace-fail \
      "subprocess.check_call(run_args, stdout=sys.stdout, stderr=sys.stderr, env=env_copy)" \
      ""

    # When a version is found in path, we can consider it is installed.
    substituteInPlace tools/idf_tools.py --replace-fail \
      "self.versions_installed = []" \
      "self.versions_installed = [self.version_in_path]"

    # Nixpkgs CMake & Ninja version are fine.
    # And explain which esp-row-elfs version is currently installed.
    ${lib.getExe jq} \
        '(.tools[] | select(.name == "cmake") | .versions)
            += [{"name": "${cmake.version}", "status": "supported"}]
         | (.tools[] | select(.name == "ninja") | .versions)
            += [{"name": "${ninja.version}", "status": "supported"}]
         | (.tools[] | select(.name == "esp-rom-elfs")) += {
           "version_cmd": ["echo", "${esp-rom-elfs.version}"],
           "version_regex": "([0-9.]+)",
           "version_regex_replace": "\\1"}' \
        tools/tools.json > tools.json
    mv tools.json tools/
  '';

  env = {
    ESP_ROM_ELF_DIR = "${esp-rom-elfs}";
    IDF_PYTHON_ENV_PATH = "${placeholder "out"}/venv";
    IDF_PYTHON_CHECK_CONSTRAINTS = "no";
  };

  dontUseCmakeConfigure = true;

  buildPhase = "bash ./install.sh";

  doCheck = true;
  checkPhase = ''
    python tools/idf_tools.py check
    python tools/idf_tools.py check-python-dependencies
  '';

  installPhase = "cp -R . $out";

  propagatedBuildInputs = [
    # ref. tools/tools.json
    ccache
    cmake
    esp-clang
    esp-rom-elfs
    esp32ulp-elf
    ninja
    openocd-esp32
    qemu-riscv32
    qemu-xtensa
    riscv32-esp-elf
    riscv32-esp-elf-gdb
    xtensa-esp-elf
    xtensa-esp-elf-gdb

    # ref. tools/requirements/requirements.core.txt
    python3Packages.setuptools
    python3Packages.packaging
    python3Packages.click
    python3Packages.pyserial
    python3Packages.cryptography
    python3Packages.pyparsing
    python3Packages.pyelftools
    python3Packages.idf-component-manager
    python3Packages.esp-coredump
    python3Packages.esptool
    python3Packages.esp-idf-kconfig
    python3Packages.esp-idf-monitor
    python3Packages.esp-idf-nvs-partition-gen
    python3Packages.esp-idf-size
    python3Packages.esp-idf-panic-decoder
    python3Packages.pyclang
    python3Packages.construct
    python3Packages.freertos-gdb
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Espressif IoT Development Framework. Official development framework for Espressif SoCs";
    homepage = "https://github.com/espressif/esp-idf";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
