{
  lib,
  python3,
  fetchFromGitHub,
  sdcc,
  yosys,
  icestorm,
  nextpnr,
  unstableGitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "glasgow";
  version = "0-unstable-2025-07-17";
  # from `pdm show`
  realVersion =
    let
      tag = builtins.elemAt (lib.splitString "-" version) 0;
      rev = lib.substring 0 7 src.rev;
    in
    "${tag}.1.dev2588+g${rev}";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "42327220a33f70b061c9103309364b6ecc1c507f";
    sha256 = "sha256-wXq5i5f6NEM/5kjqmBNXEvRqaN6B+/qHAZ9jhNhmG58=";
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
    make -C firmware LIBFX2=${python3.pkgs.fx2}/share/libfx2
    cp firmware/glasgow.ihex software/glasgow
    cd software
    export PDM_BUILD_SCM_VERSION="${realVersion}"
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
    "${yosys}/bin/yosys"
    "--set"
    "ICEPACK"
    "${icestorm}/bin/icepack"
    "--set"
    "NEXTPNR_ICE40"
    "${nextpnr}/bin/nextpnr-ice40"
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = "https://github.com/GlasgowEmbedded/Glasgow";
    license = licenses.bsd0;
    maintainers = with maintainers; [
      flokli
      thoughtpolice
    ];
    mainProgram = "glasgow";
  };
}
