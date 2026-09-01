{
  lib,
  python3Packages,
  fetchFromGitHub,
  icestorm,
  nextpnr,
  sdcc,
  yosys,
}:

python3Packages.buildPythonApplication rec {
  pname = "glasgow";
  version = "0-unstable-2025-07-25";
  # Similar to `pdm show`, but without the commit counter
  pdmVersion =
    let
      tag = builtins.elemAt (lib.splitString "-" version) 0;
      rev = lib.substring 0 7 src.rev;
    in
    "${tag}.1.dev0+g${rev}";
  # Usually the latest commit ID touching the `firmware` directory. Differs from src/rev!
  # Run `git log -1 --abbrev=8 --pretty=%h HEAD .` inside the firmware/fx2 dir.
  firmwareGitRev = "12b5cfb3";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "c424688ff0d7faee49198bbdb2a34b1026534350";
    hash = "sha256-0pVQg3FSBQ8A4eLnAxFdicOiCvAYmKwHnSoLGx1MLxM=";
  };

  nativeBuildInputs = [
    sdcc
  ];

  build-system = [
    python3Packages.pdm-backend
  ];

  dependencies = with python3Packages; [
    aiohttp
    amaranth
    cobs
    enum-tools
    fx2
    importlib-resources
    libusb1
    packaging
    platformdirs
    pyvcd
    typing-extensions
    tqdm
  ];

  nativeCheckInputs = [
    # pytestCheckHook discovers way less tests
    python3Packages.unittestCheckHook
    icestorm
    nextpnr
    yosys
  ];

  unittestFlags = [ "-v" ];

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    make -C firmware/fx2 GIT_TREE_DIRTY=0 GIT_REV_SHORT=${firmwareGitRev} LIBFX2=${python3Packages.fx2}/share/libfx2

    # Normalize the .ihex file, see ./software/deploy-firmware.sh.
    ${python3Packages.python.withPackages (p: [ p.fx2 ])}/bin/python firmware/fx2/normalize.py \
      firmware/fx2/build/firmware.ihex firmware/fx2/glasgow.ihex

    # Ensure the compiled firmware is exactly the same as the one shipped in the repo.
    if ! cmp -s firmware/fx2/glasgow.ihex software/glasgow/hardware/firmware-fx2.ihex; then
      echo >&2 "Firmware doesn't reproduce!"
      diff -u software/glasgow/hardware/firmware-fx2.ihex firmware/fx2/glasgow.ihex
      exit 1
    fi

    cd software
    export PDM_BUILD_SCM_VERSION="${pdmVersion}"
  '';

  # installCheck tries to build_ext again
  doInstallCheck = false;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src/config/*.rules $out/etc/udev/rules.d
  '';

  preCheck = ''
    export PYTHONWARNINGS="ignore::DeprecationWarning"
    # tests attempt to cache bitstreams
    # for linux:
    export XDG_CACHE_HOME=$TMPDIR
    # for darwin:
    export HOME=$TMPDIR
  '';

  makeWrapperArgs = [
    "--set"
    "YOSYS"
    (lib.getExe yosys)
    "--set"
    "ICEPACK"
    "${icestorm}/bin/icepack"
    "--set"
    "NEXTPNR_ICE40"
    "${nextpnr}/bin/nextpnr-ice40"
  ];

  meta = {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = "https://github.com/GlasgowEmbedded/Glasgow";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      flokli
      thoughtpolice
    ];
    mainProgram = "glasgow";
  };
}
