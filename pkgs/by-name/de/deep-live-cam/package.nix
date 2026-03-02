{
  basicsr ? python312Packages.basicsr,
  config,
  customtkinter,
  cv2-enumerate-cameras,
  fetchFromGitHub,
  fetchurl,
  gfpgan,
  insightface,
  lib,
  numpy,
  onnx,
  onnxruntime,
  opencv-python,
  opencv-python-withCuda,
  opennsfw2,
  pillow,
  protobuf,
  psutil,
  pygrabber,
  python312Packages,
  setuptools,
  tensorflow,
  tensorflowWithCuda,
  tk,
  tkinter,
  torch,
  torchWithCuda,
  torchvision,
  torchvisionWithCuda,
  typing-extensions,
  wheel,
}:
let
  /**
    TODO: maybe update following preexisting packages to be aware of `config.cudaSupport`
  */
  albucore-withCuda = python312Packages.albucore.override {
    opencv-python = opencv-python-withCuda;
  };
  albumentations-withCuda = python312Packages.albumentations.override {
    opencv-python = opencv-python-withCuda;
    albucore = albucore-withCuda;
  };
  insightface-withCuda = python312Packages.insightface.override {
    albumentations = albumentations-withCuda;
    opencv4 = python312Packages.opencv4Full;
  };

  huggingface =
    let
      git-hash = "9c262a23b944b4dc74fcf3643e56f4fdab6212b5";
    in
    {
      ## Wanted by CPU and maybe other `--run` runners?
      hacksider.deep-live-cam.GFPGAN = fetchurl {
        url = "https://huggingface.co/hacksider/deep-live-cam/resolve/${git-hash}/GFPGANv1.4.pth";
        hash = "sha256-4s1HA6sU9NAf0Tg6iosmb5pYM9rO6OannTvyGhtr5a0=";
        meta = {
          license = lib.licenses.gpl3;
        };
      };

      ## Wanted by CPU and maybe other `--run` runners?
      hacksider.deep-live-cam.inswapper_128_fp16 = fetchurl {
        url = "https://huggingface.co/hacksider/deep-live-cam/resolve/${git-hash}/inswapper_128_fp16.onnx";
        hash = "sha256-bVGpJ4ofZQz/78GLpT84vydpv0u/+JJngiz3KUX4o4s=";
        meta = {
          license = lib.licenses.gpl3;
        };
      };

      ## Wanted by Cuda?
      hacksider.deep-live-cam.inswapper_128 = fetchurl {
        url = "https://huggingface.co/hacksider/deep-live-cam/resolve/${git-hash}/inswapper_128.onnx";
        hash = "sha256-5KPwjHU8ty0E4Qqg99vj3uu/OVZ9Tq1tzgjpiqSeFq8=";
        meta = {
          license = lib.licenses.gpl3;
        };
      };
    };
in
python312Packages.buildPythonApplication (finalAttrs: {
  pname = "deep-live-cam";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "hacksider";
    repo = "Deep-Live-Cam";

    # tag = finalAttrs.version;
    # hash = "sha256-zLRGRuQShXNY/ILeSgBfp/MxJVyVhZIylj/Z/w/8LME=";

    rev = "d0f81ed755f154dea73355d724fd6a55b9feabbd";
    hash = "sha256-sTtmnAAP6DWtVwjdb0ayXBpOhQ4pd2JuAg3nkbLuGNI=";
  };

  doCheck = false;
  pyproject = true;

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    basicsr
    customtkinter
    cv2-enumerate-cameras
    gfpgan
    numpy
    onnx
    onnxruntime
    opennsfw2
    pillow
    protobuf
    psutil
    pygrabber
    tk
    tkinter
    typing-extensions
  ]
  ++ lib.lists.optionals (!config.cudaSupport) [
    insightface
    opencv-python
    tensorflow
    torch
    torchvision
  ]
  ++ lib.lists.optionals config.cudaSupport [
    insightface-withCuda
    opencv-python-withCuda
    tensorflowWithCuda
    torchWithCuda
    torchvisionWithCuda
  ];

  preBuild = ''
    ## TODO: consider pinning versions to what `requirements.txt` prescribes
    sed -i "{
      s#^.*--extra-index-url.*##g;
      s#^.*git+https://.*##g;
      s#numpy.*#numpy#g;
      s#opencv-python.*#opencv-python#g;
      s#cv2_enumerate_cameras.*#cv2_enumerate_cameras#g;
      # s#insightface.*##g;
      s#onnx.*#onnx#g;
      s#psutil.*#psutil#g;
      s#tk.*#tkinter#g;
      s#pillow.*#pillow#g;
      s#onnxruntime-gpu.*#onnxruntime#g;
      s#protobuf.*#protobuf#g;
    }" requirements.txt;

    ## See -> https://github.com/pypa/setuptools/blob/fec08a87e69f296e85f89aad82ca49f45833adbd/docs/userguide/package_discovery.rst#src-layout
    mkdir ./src;
    touch ./src/__init__.py;
    mv run.py tkinter_fix.py modules ./src/;

    tee setup.py <<'EOF'
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    setup(
        name='${finalAttrs.pname}',
        version='${finalAttrs.version}',
        author='${finalAttrs.src.owner}',
        description='${finalAttrs.meta.description}',
        install_requires=install_requires,
        scripts=[ 'src/run.py' ],
    )
    EOF
  '';

  postInstall =
    let
      models-dir = "$out/lib/python3.12/site-packages/models";
      modules-dir = "$out/lib/python3.12/site-packages/modules";
    in
    ''
      install -Dm444 ${huggingface.hacksider.deep-live-cam.GFPGAN} -T ${models-dir}/GFPGANv1.4.pth;
      install -Dm444 ${huggingface.hacksider.deep-live-cam.inswapper_128} -T ${models-dir}/inswapper_128.onnx;
      install -Dm444 ${huggingface.hacksider.deep-live-cam.inswapper_128_fp16} -T ${models-dir}/inswapper_128_fp16.onnx;
      install -Dm444 ${huggingface.hacksider.deep-live-cam.inswapper_128_fp16} -T ${models-dir}/processors/frame/inswapper_128_fp16.onnx;
      install -Dm444 ./src/modules/ui.json -t ${modules-dir};
    '';

  meta = {
    changelog = "https://github.com/hacksider/Deep-Live-Cam/releases/tag/${finalAttrs.version}";
    description = "real time face swap and one-click video deepfake with only a single image";
    homepage = "https://github.com/hacksider/Deep-Live-Cam/tree/${finalAttrs.version}";
    ## TODO: maybe double-check license is restricted to only AGPL v3
    license = with lib.licenses; [ agpl3Only ];
    maintainers = with lib.maintainers; [
      S0AndS0
    ];
  };
})
