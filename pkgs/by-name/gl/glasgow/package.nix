{ lib
, python3
, fetchFromGitHub
, sdcc
, yosys
, icestorm
, nextpnr
, unstableGitUpdater
}:

python3.pkgs.buildPythonApplication rec {
  pname = "glasgow";
  version = "0-unstable-2024-12-17";
  # from `pdm show`
  realVersion = let
      tag = builtins.elemAt (lib.splitString "-" version) 0;
      rev = lib.substring 0 7 src.rev;
    in "${tag}.1.dev2085+g${rev}";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "GlasgowEmbedded";
    repo = "glasgow";
    rev = "999d6e7e3ba806acc9aac8c375c28358483583cc";
    sha256 = "sha256-bDn8v2kKgj0T1NItR1now4+uJp91bfiRRBpKEnKGLAs=";
  };

  nativeBuildInputs = [
    python3.pkgs.pdm-backend
    sdcc
  ];

  propagatedBuildInputs = with python3.pkgs; [
    typing-extensions
    amaranth
    packaging
    platformdirs
    fx2
    libusb1
    pyvcd
    aiohttp
  ];

  nativeCheckInputs = [
    python3.pkgs.unittestCheckHook
    yosys
    icestorm
    nextpnr
  ];

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
    "--set" "YOSYS" "${yosys}/bin/yosys"
    "--set" "ICEPACK" "${icestorm}/bin/icepack"
    "--set" "NEXTPNR_ICE40" "${nextpnr}/bin/nextpnr-ice40"
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    description = "Software for Glasgow, a digital interface multitool";
    homepage = "https://github.com/GlasgowEmbedded/Glasgow";
    license = licenses.bsd0;
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "glasgow";
  };
}
