{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  nixosTests,
  python313Packages,
  runCommand,
  wrapGAppsHook4,
  gobject-introspection,
  cairo,
  coreutils,
  gawk,
  gdk-pixbuf,
  glib,
  graphene,
  gst_all_1,
  gtk4,
  libadwaita,
  libglvnd,
  libxcb,
  makeShellWrapper,
  onnx,
  pango,
  pipewire,
  psmisc,
  pulseaudio,
  python3Packages,
  replaceVars,
  v4l-utils,
  writableTmpDirAsHomeHook,
  writeShellScript,
  zlib,
}:

let
  av = python313Packages.av.overridePythonAttrs (oldAttrs: rec {
    version = "17.0.1";
    src = fetchFromGitHub {
      owner = "PyAV-Org";
      repo = "PyAV";
      tag = "v${version}";
      hash = "sha256-IS+qSwvpNbhOazkgZh9hzzaTLxSgU7uZjGmaOIkhskc=";
    };
    disabledTests = (oldAttrs.disabledTests or [ ]) ++ [ "test_skip_samples_remux" ];
  });

  audiolab = python313Packages.audiolab.override { inherit av; };

  pyrnnoise = python313Packages.pyrnnoise.override { inherit audiolab; };

  onnxruntime = python313Packages.onnxruntime.overridePythonAttrs (oldAttrs: rec {
    version = "1.24.4";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/7f/72/105ec27a78c5aa0154a7c0cd8c41c19a97799c3b12fc30392928997e3be3/onnxruntime-${version}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-4wyXK8AuBykRqrtokUU+xzeVOGwK8rdhtlREuKTEdF8=";
    };
    unpackPhase = ''
      mkdir dist
      cp "$src" "dist/onnxruntime-${version}-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl"
    '';
    meta = oldAttrs.meta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
    };
  });

  onnx_1_22 = onnx.overrideAttrs (oldAttrs: rec {
    version = "1.22.0";
    src = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      tag = "v${version}";
      hash = "sha256-gc65t/VN3kdvV9tiFoOk6Sw+OZe4Udgm3VcZPP9gzpE=";
    };
    env = oldAttrs.env // {
      BUILD_SHARED_LIBS = "0";
    };
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ python3Packages.scikit-build-core ];
    postPatch = (oldAttrs.postPatch or "") + ''
      substituteInPlace pyproject.toml \
        --replace-fail '"protobuf==4.25.1"' '"protobuf>=4.25.1"'
    '';
    postInstall = ''
      mkdir -p "$out"
    '';
  });

  pythonOnnx = (python313Packages.onnx.override { onnx = onnx_1_22; }).overridePythonAttrs (_: {
    enabledTestPaths = [ "onnx/test" ];
  });

  pythonDeps =
    (with python313Packages; [
      av
      click
      mediapipe
      numpy
      packaging
      pillow
      psutil
      pygobject3
      pyrnnoise
      scipy
    ])
    ++ [
      onnxruntime
      pythonOnnx
    ];

  pythonPath = python313Packages.makePythonPath pythonDeps;

  v4l-utils-headless = v4l-utils.override {
    withBPF = false;
    withGUI = false;
  };

  requirementsCheck = writeShellScript "nvbroadcast-requirements-check" ''
    if [ -n "''${NVBROADCAST_SKIP_REQUIREMENTS_CHECK:-}" ]; then
      exit 0
    fi

    warn() {
      printf 'nvbroadcast: warning: %s\n' "$*" >&2
    }

    if [ ! -e /dev/nvidiactl ] && [ ! -e /proc/driver/nvidia/version ]; then
      warn "NVIDIA driver was not detected; upstream recommends NVIDIA driver 525 or newer."
    fi

    if command -v nvidia-smi >/dev/null 2>&1; then
      driver_version="$(nvidia-smi --query-gpu=driver_version --format=csv,noheader 2>/dev/null)"
      driver_version="''${driver_version%%$'\n'*}"
      driver_major="''${driver_version%%.*}"
      case "$driver_major" in
        "" | *[!0-9]*)
          warn "could not read NVIDIA driver version; upstream recommends 525 or newer."
          ;;
        *)
          if [ "$driver_major" -lt 525 ]; then
            warn "NVIDIA driver $driver_version detected; upstream recommends 525 or newer."
          fi
          ;;
      esac
    elif [ -e /dev/nvidiactl ] || [ -e /proc/driver/nvidia/version ]; then
      warn "nvidia-smi is not in PATH; cannot verify upstream NVIDIA driver 525+ requirement."
    fi

    if [ ! -d /sys/module/v4l2loopback ]; then
      warn "v4l2loopback is not loaded; virtual camera output may be unavailable."
    fi

    if ! ${pipewire}/bin/pw-cli info 0 >/dev/null 2>&1; then
      warn "PipeWire does not appear reachable; camera/audio routing may fail."
    fi

    if ! ${pulseaudio}/bin/pactl info >/dev/null 2>&1; then
      warn "PulseAudio-compatible server does not appear reachable; virtual microphone routing may fail."
    fi
  '';
in
python313Packages.buildPythonApplication (finalAttrs: {
  pname = "nvbroadcast";
  version = "1.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Hkshoonya";
    repo = "nvidia-broadcast-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z/OGeSOlnKKv9vFpY+8gD3ghwQriUVTEBq4BTFAbE5o=";
  };

  patches = [
    (replaceVars ./runtime-site.patch {
      pip = lib.getExe' python313Packages.pip "pip";
      inherit (finalAttrs) version;
    })
  ];

  build-system = with python313Packages; [
    setuptools
    wheel
  ];

  pythonRemoveDeps = [
    # mediapipe already propagates opencv-contrib-python, which provides cv2.
    "opencv-python-headless"
  ];

  pythonRelaxDeps = [
    "av"
    "protobuf"
  ];

  dependencies = pythonDeps;

  nativeBuildInputs = [
    gobject-introspection
    makeShellWrapper
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    graphene
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gtk4
    libadwaita
    pango
  ];

  nativeCheckInputs = [
    pipewire
    psmisc
    pulseaudio
    python313Packages.pytestCheckHook
    v4l-utils-headless
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export MPLCONFIGDIR=$TMPDIR/matplotlib
    export NVBROADCAST_RUNTIME_SITE=$TMPDIR/runtime-site
  '';

  # Requires real GPU, camera, and v4l2loopback devices.
  disabledTestPaths = [ "tests/test_integration.py" ];

  pythonImportsCheck = [ "nvbroadcast" ];

  dontWrapGApps = true;

  postPatch = ''
    # Python's sys.prefix points at the interpreter, not this application output.
    substituteInPlace src/nvbroadcast/core/resources.py \
      --replace-fail 'Path(sys.prefix) / "share"' \
        'Path("${placeholder "out"}") / "share"'

    # Upstream's fixed system PATH is empty in the Nix build sandbox.
    substituteInPlace scripts/native_package_upgrade.sh.in \
      --replace-fail 'PATH=/usr/sbin:/usr/bin:/sbin:/bin' \
        'PATH=${
          lib.makeBinPath [
            coreutils
            gawk
          ]
        }:/usr/sbin:/usr/bin:/sbin:/bin'
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  makeWrapperArgs = [
    "--prefix"
    "GST_PLUGIN_SYSTEM_PATH_1_0"
    ":"
    (lib.makeSearchPath "lib/gstreamer-1.0" [
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
    ])
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [
      cairo
      glib
      gtk4
      libadwaita
      libglvnd
      libxcb
      stdenv.cc.cc
      zlib
    ])
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      pipewire
      psmisc
      pulseaudio
      v4l-utils-headless
    ])
    # Upstream launches child Python processes via sys.executable.
    "--prefix"
    "PYTHONPATH"
    ":"
    "${placeholder "out"}/${python313Packages.python.sitePackages}:${pythonPath}"
  ];

  postFixup = ''
    mv "$out/bin/nvbroadcast" "$out/bin/.nvbroadcast-gapps-wrapped"
    makeShellWrapper "$out/bin/.nvbroadcast-gapps-wrapped" "$out/bin/nvbroadcast" \
      --run ${requirementsCheck}
  '';

  passthru = {
    tests = {
      help = runCommand "${finalAttrs.pname}-help-test" { } ''
        export MPLCONFIGDIR=$TMPDIR/matplotlib
        export NVBROADCAST_SKIP_REQUIREMENTS_CHECK=1
        export NVBROADCAST_RUNTIME_SITE=$TMPDIR/runtime-site
        ${lib.getExe finalAttrs.finalPackage} --help > help.txt
        ${finalAttrs.finalPackage}/bin/nvbroadcast-vcam --help > vcam-help.txt
        grep -F "Show help options" help.txt
        grep -F "Virtual Camera Service" vcam-help.txt
        ! grep -F "Runtime dependency installation is disabled" \
          ${finalAttrs.finalPackage}/${python313Packages.python.sitePackages}/nvbroadcast/core/dependency_installer.py
        grep -F 'getattr(b, "_MAX_INFER_HEIGHT", "?")' \
          ${finalAttrs.finalPackage}/${python313Packages.python.sitePackages}/nvbroadcast/app.py
        PYTHONPATH=${finalAttrs.finalPackage}/${python313Packages.python.sitePackages}:${pythonPath} \
          ${python313Packages.python.interpreter} -c '
        import os
        import sys
        import mediapipe
        import onnxruntime
        from nvbroadcast.core import dependency_installer, resources
        assert onnxruntime.__version__ == "1.24.4"
        runtime_site = os.environ["NVBROADCAST_RUNTIME_SITE"]
        assert runtime_site not in sys.path
        assert not os.path.exists(runtime_site)
        dependency_installer._ensure_runtime_site()
        assert runtime_site in sys.path
        assert os.path.isdir(runtime_site)
        assert resources.find_app_icon().is_file()
        assert resources.find_app_icon_png().is_file()
        assert resources.find_backgrounds_dir().is_dir()
        '
        touch $out
      '';

      inherit (nixosTests) nvbroadcast;
    };
  };

  meta = {
    description = "AI-powered virtual camera with background removal and noise cancellation";
    longDescription = ''
      NV Broadcast — Unofficial NVIDIA Broadcast for Linux and other OS.

      AI-powered virtual camera with background removal, blur, replacement,
      video enhancement, and noise cancellation. GPU accelerated. Open source.
    '';
    homepage = "https://github.com/Hkshoonya/nvidia-broadcast-linux";
    changelog = "https://github.com/Hkshoonya/nvidia-broadcast-linux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Tenshock ];
    mainProgram = "nvbroadcast";
    platforms = python313Packages.mediapipe.meta.platforms;
  };
})
