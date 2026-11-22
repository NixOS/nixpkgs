{
  lib,
  python3Packages,
  fetchFromGitHub,

  # patches
  replaceVars,
  ffmpeg,
  imagemagick,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "compress-pptx";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "compress-pptx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DTN/R8ioSp63txLB4ac8P0k3CXQN1ikr9qgYeP2dQSM=";
  };

  patches = [
    (replaceVars ./inject-dependency-paths.patch {
      ffmpeg = lib.getExe ffmpeg;
      magick = lib.getExe imagemagick;
    })
  ];

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    ffmpeg-progress-yield
    tqdm
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  meta = {
    description = "Compress PPTX files";
    longDescription = ''
      Compress a PPTX or POTX file, converting all PNG/TIFF images to lossy
      JPEGs.
    '';
    homepage = "https://github.com/slhck/compress-pptx";
    license = lib.licenses.mit;
    changelog = "https://github.com/slhck/compress-pptx/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "compress-pptx";
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
