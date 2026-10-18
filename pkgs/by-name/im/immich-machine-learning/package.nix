{
  lib,
  immich,
  ocl-icd,
  openvino,
  python3,
  nixosTests,
  stdenv,
}:
let
  python = python3.override {
    self = python;
  };
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "immich-machine-learning";
  inherit (immich) version;
  src = "${immich.src}/machine-learning";
  pyproject = true;

  postPatch = ''
    substituteInPlace immich_ml/sessions/ort.py \
      --replace-fail 'Path(ort.__file__).parent / "capi" / "libopenvino_c.so"' '"${lib.getLib openvino}/lib/libopenvino_c.so"' \
      --replace-fail '"libOpenCL.so.1"' '"${lib.getLib ocl-icd}/lib/libOpenCL.so.1"'
  '';

  pythonRelaxDeps = [
    "onnx"
  ];

  build-system = with python.pkgs; [
    hatchling
  ];

  dependencies =
    with python.pkgs;
    [
      aiocache
      fastapi
      gunicorn
      huggingface-hub
      numpy
      onnx
      opencv-python-headless
      orjson
      pillow
      pydantic
      pydantic-settings
      python-multipart
      rich
      tokenizers
      uvicorn
      rapidocr

      finalAttrs.passthru.immich-model
    ]
    ++ uvicorn.optional-dependencies.standard;

  # aarch64-linux tries to get cpu information from /sys, which isn't available
  # inside the nix build sandbox.
  doCheck = stdenv.buildPlatform.system != "aarch64-linux";

  nativeCheckInputs = with python.pkgs; [
    httpx
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/share/immich
    cp immich_ml/log_conf.json $out/share/immich

    cp -r ann $out/${python.sitePackages}/

    makeWrapper ${lib.getExe python.pkgs.gunicorn} "''${!outputBin}"/bin/machine-learning \
      --prefix PYTHONPATH : "$out/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}" \
      --set-default MACHINE_LEARNING_WORKERS 1 \
      --set-default MACHINE_LEARNING_WORKER_TIMEOUT 120 \
      --set-default MACHINE_LEARNING_CACHE_FOLDER /var/cache/immich \
      --set-default IMMICH_HOST "[::]" \
      --set-default IMMICH_PORT 3003 \
      --add-flags "immich_ml.main:app -k immich_ml.config.CustomUvicornWorker \
        -w \"\$MACHINE_LEARNING_WORKERS\" \
        -b \"\$IMMICH_HOST:\$IMMICH_PORT\" \
        -t \"\$MACHINE_LEARNING_WORKER_TIMEOUT\"
        --log-config-json $out/share/immich/log_conf.json"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich;
    };
    immich-model = python.pkgs.callPackage ./immich-model.nix { };
  };

  meta = {
    description = "${immich.meta.description} (machine learning component)";
    homepage = "https://github.com/immich-app/immich/tree/main/machine-learning";
    mainProgram = "machine-learning";
    inherit (immich.meta) license maintainers platforms;
  };
})
