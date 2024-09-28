{
  lib,
  fetchFromGitHub,
  immich,
  python3,
}:
let
  python = python3.override {
    self = python;

    packageOverrides = self: super: {
      pydantic = super.pydantic_1;

      versioningit = super.versioningit.overridePythonAttrs (_: {
        doCheck = false;
      });

      albumentations = super.albumentations.overridePythonAttrs (_: rec {
        version = "1.4.3";
        src = fetchFromGitHub {
          owner = "albumentations-team";
          repo = "albumentations";
          rev = version;
          hash = "sha256-JIBwjYaUP4Sc1bVM/zlj45cz9OWpb/LOBsIqk1m+sQA=";
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication {
  pname = "immich-machine-learning";
  inherit (immich) version;
  src = "${immich.src}/machine-learning";
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'

    # AttributeError: module 'cv2' has no attribute 'Mat'
    substituteInPlace app/test_main.py --replace-fail ": cv2.Mat" ""
  '';

  pythonRelaxDeps = [ "setuptools" ];
  pythonRemoveDeps = [ "opencv-python-headless" ];

  build-system = with python.pkgs; [
    poetry-core
    cython
  ];

  dependencies =
    with python.pkgs;
    [
      insightface
      opencv4
      pillow
      fastapi
      uvicorn
      aiocache
      rich
      ftfy
      setuptools
      python-multipart
      orjson
      gunicorn
      huggingface-hub
      tokenizers
      pydantic
    ]
    ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python.pkgs; [
    httpx
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  postInstall = ''
    mkdir -p $out/share/immich
    cp log_conf.json $out/share/immich

    cp -r ann $out/${python.sitePackages}/

    makeWrapper ${lib.getExe python.pkgs.gunicorn} "''${!outputBin}"/bin/machine-learning \
      --prefix PYTHONPATH : "$out/${python.sitePackages}:$PYTHONPATH" \
      --set-default MACHINE_LEARNING_WORKERS 1 \
      --set-default MACHINE_LEARNING_WORKER_TIMEOUT 120 \
      --set-default MACHINE_LEARNING_CACHE_FOLDER /var/cache/immich \
      --set-default IMMICH_HOST "[::]" \
      --set-default IMMICH_PORT 3003 \
      --add-flags "app.main:app -k app.config.CustomUvicornWorker \
        -w \"\$MACHINE_LEARNING_WORKERS\" \
        -b \"\$IMMICH_HOST:\$IMMICH_PORT\" \
        -t \"\$MACHINE_LEARNING_WORKER_TIMEOUT\"
        --log-config-json $out/share/immich/log_conf.json"
  '';

  meta = {
    description = "Self-hosted photo and video backup solution (machine learning component)";
    homepage = "https://immich.app/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
    mainProgram = "machine-learning";
    inherit (immich.meta) platforms;
  };
}
