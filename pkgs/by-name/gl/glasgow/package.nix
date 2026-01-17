{
  lib,
  python3,
  fetchFromGitHub,
  sdcc,
  yosys,
  icestorm,
  nextpnr,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "glasgow";
  version = "0-unstable-2025-12-22";
  # Similar to `pdm show`, but without the commit counter
  pdmVersion =
    let
      tag = builtins.elemAt (lib.splitString "-" version) 0;
      rev = lib.substring 0 7 src.rev;
    in
    "${tag}.1.dev0+g${rev}";
  # The latest commit ID touching the `firmware` directory, before a "deploy firmware" commit.
  # Differs from rev!
  firmwareGitRev = "8b5afc70";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "ccee116d8b59f25ed0874d152f6b9f9974b185f1";
    hash = "sha256-2fF0lPfRtpci76q4fEhWAwLBXP0kfIP3dH5z8u/+yd8=";
  };

  nativeBuildInputs = [
    sdcc
  ];

  build-system = [
    python3.pkgs.pdm-backend
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    amaranth
    cobs
    fx2
    importlib-resources
    libusb1
    packaging
    platformdirs
    pyvcd
    typing-extensions
  ];

  nativeCheckInputs = [
    # pytestCheckHook discovers way less tests
    python3.pkgs.unittestCheckHook
    icestorm
    nextpnr
    yosys
  ];

  unittestFlags = [ "-v" ];

  enableParallelBuilding = true;

  __darwinAllowLocalNetworking = true;

  preBuild = ''
    make -C firmware GIT_REV_SHORT=${firmwareGitRev} LIBFX2=${python3.pkgs.fx2}/share/libfx2

    # Normalize the .ihex file, see ./software/deploy-firmware.sh.
    ${python3.withPackages (p: [ p.fx2 ])}/bin/python firmware/normalize.py \
      firmware/glasgow.ihex firmware/glasgow.ihex

    # Ensure the compiled firmware is exactly the same as the one shipped in the repo.
    cmp -s firmware/glasgow.ihex software/glasgow/hardware/firmware.ihex

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
