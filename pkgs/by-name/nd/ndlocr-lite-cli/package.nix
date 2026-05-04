{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  runCommand,
  gnugrep,
  nix-update-script,
  ndlocr-lite-cli,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ndlocr-lite-cli";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndl-lab";
    repo = "ndlocr-lite";
    tag = finalAttrs.version;
    hash = "sha256-OTeOzePLtIjF4T6hsfX7n/K4A6V6zWE+Pmw2h/SXm2k=";
  };

  __structuredAttrs = true;

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRemoveDeps = [
    "flet" # Required only for GUI
  ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    dill
    lxml
    networkx
    onnxruntime
    pillow
    ordered-set
    protobuf
    pyparsing
    pyyaml
    tqdm
    reportlab
    pypdfium2
    numpy
    opencv-python-headless
  ];

  pythonImportsCheck = [
    "ocr"
    "deim"
    "parseq"
    "ndl_parser"
  ];

  # has no tests
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/ndlocr-lite" --help
    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      sample-ocr =
        runCommand "${finalAttrs.pname}-sample-ocr-test"
          {
            nativeBuildInputs = [
              ndlocr-lite-cli
              gnugrep
            ];
          }
          ''
            basename='digidepo_2531162_0024'
            ndlocr-lite --sourceimg "${finalAttrs.src}/resource/$basename.jpg" --output ./
            grep --fixed-strings '5.3' "$basename.txt" | tee "$out"
          '';
    };

    updateScript = nix-update-script {
      # Upstream sometimes marks stable tags as "Pre-release".
      extraArgs = [ "--use-github-releases" ];
    };
  };

  meta = {
    description = "OCR for Japanese documents";
    longDescription = ''
      Lightweight version of NDLOCR. It works without a GPU.
    '';
    homepage = "https://github.com/ndl-lab/ndlocr-lite";
    changelog = "https://github.com/ndl-lab/ndlocr-lite/releases/tag/${finalAttrs.version}";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "ndlocr-lite";
    platforms = with lib.platforms; unix ++ windows;

    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    broken = with stdenv.hostPlatform; isLinux && isAarch64;
  };
})
