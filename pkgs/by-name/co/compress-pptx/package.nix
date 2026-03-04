{
  python3Packages,
  fetchFromGitHub,
  lib,
  pkgs,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "compress-pptx";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "compress-pptx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zjq/hC8B6zrd30t80i1XP5LzmmnDaNDRTn4k4uQ30b8=";
  };

  build-system = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    ffmpeg-progress-yield
    tqdm
  ];

  buildInputs = with pkgs; [
    ffmpeg
    imagemagick
  ];

  # Better with a patch or just submit an upstream PR?
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'uv_build>=0.8.14,<0.9.0' 'uv_build>=0.8.14,<1.0.0'
  '';

  meta = with lib; {
    description = "Compress PPTX files";
    longDescription = ''
      Compress a PPTX or POTX file, converting all PNG/TIFF images to lossy
      JPEGs.
    '';
    homepage = "https://github.com/slhck/compress-pptx";
    license = licenses.mit;
    changelog = "https://github.com/slhck/compress-pptx/releases/tag/v${finalAttrs.version}";
    mainProgram = "compress-pptx";
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
