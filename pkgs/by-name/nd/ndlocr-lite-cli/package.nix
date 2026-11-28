{
  lib,
  fetchFromGitHub,
  python3Packages,
  versionCheckHook,
  runCommand,
  gnugrep,
  nix-update-script,
  fetchurl,
  ndlocr-lite-cli,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ndlocr-lite-cli";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndl-lab";
    repo = "ndlocr-lite";
    tag = finalAttrs.version;
    hash = "sha256-AeqxIetG7OvxBVLWiwCTx+LXqHJ0a2e0+09yc6Ofs3Q=";
  };

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
    pypdf
    pyyaml
    tqdm
    reportlab
    pypdfium2
    numpy
    opencv-python-headless
    cryptography
    markdown-it-py
  ];

  pythonImportsCheck = [
    "ocr"
    "deim"
    "parseq"
    "ndl_parser"
    "tcy_wrapper"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    tests =
      let
        detModel = fetchurl {
          url = "https://lab.ndl.go.jp/dataset/ndlocr-lite/onnx/v2/deim-s-1024x1024-261124.onnx";
          hash = "sha256-+aQchFPdaH83C+4Zn9bUfs9YPMFPHYOaC0Fts5s1bow=";
        };
        recModel100 = fetchurl {
          url = "https://lab.ndl.go.jp/dataset/ndlocr-lite/onnx/v2/parseq-ndl-24x768-100-tiny-153epoch-261124.onnx";
          hash = "sha256-BkYrDb1bC4UIVFyMPUhc8g2/T/plL+FF5pyedFcIBgI=";
        };
        recModel30 = fetchurl {
          url = "https://lab.ndl.go.jp/dataset/ndlocr-lite/onnx/v2/parseq-ndl-24x256-30-tiny-499epoch-261124.onnx";
          hash = "sha256-Bj7FsyAbznnVbDrXO1cmz3bsaoL0LhGolGauaDdVKWw=";
        };
        recModel50 = fetchurl {
          url = "https://lab.ndl.go.jp/dataset/ndlocr-lite/onnx/v2/parseq-ndl-24x384-50-tiny-278epoch-261124.onnx";
          hash = "sha256-092edzOu/1yfUGh8fabo0BkVoL8Hz77+HZrFgkHGFHE=";
        };
      in
      {
        sample-ocr =
          runCommand "${finalAttrs.pname}-sample-ocr-test"
            {
              nativeBuildInputs = [
                ndlocr-lite-cli
                gnugrep
              ];
            }
            ''
              basename='digidepo_3048008_0025'
              ndlocr-lite \
                --det-weights "${detModel}" \
                --rec-weights "${recModel100}" \
                --rec-weights30 "${recModel30}" \
                --rec-weights50 "${recModel50}" \
                --sourceimg "${finalAttrs.src}/resource/$basename.jpg" --output ./
              grep --fixed-strings '海の家' "$basename.txt" | tee "$out"
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
    changelog = "https://github.com/ndl-lab/ndlocr-lite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "ndlocr-lite";
    platforms = with lib.platforms; unix ++ windows;
  };
})
