{
  fetchurl,
  frigate,
  lib,
  stdenv,
  ...
}:

let
  inherit (frigate) python3Packages;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ssdlite_mobilenet_v2_coco";
  version = "2018_05_09";

  src = fetchurl {
    url = "http://download.tensorflow.org/models/object_detection/ssdlite_mobilenet_v2_coco_2018_05_09.tar.gz";
    hash = "sha256-VCRFzOg02/u33xmRQl1HXoWi1+xoxgpPJiuxiqwQyLI=";
  };

  nativeBuildInputs = [
    python3Packages.openvino
  ];

  postPatch = ''
    cp --no-preserve=mode ${frigate.src}/docker/main/build_ov_model.py .
    substituteInPlace build_ov_model.py \
      --replace-fail "/models/${finalAttrs.pname}_${finalAttrs.version}" "./" \
      --replace-fail "/models/" "dist/"
  '';

  buildPhase = ''
    runHook preBuild
    mkdir dist
    python3 build_ov_model.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp dist/*.{bin,xml} $out/
    runHook postInstall
  '';

  passthru = {
    model = "${finalAttrs.finalPackage}/ssdlite_mobilnet_v2.xml";
    labelmap = fetchurl {
      url = "https://github.com/openvinotoolkit/open_model_zoo/raw/master/data/dataset_classes/coco_91cl_bkgr.txt";
      hash = "sha256-cQBhlxYm2yS6s7rm/06c5uZmUFZZkBI/P4bxLThbN9E=";
      # https://github.com/blakeblackshear/frigate/commit/8ac3114f9a014356272b8a44b752e82df342f245
      postFetch = ''
        sed -i "s/truck/car/g" $out
      '';
    };
  };

  meta = {
    description = "Object detection model trained on the COCO dataset.";
    license = lib.licenses.asl20;
    homepage = "https://www.kaggle.com/models/tensorflow/ssdlite-mobilenet-v2/";
  };
})
