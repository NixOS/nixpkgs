{
  lib,
  src,
  immich,
  python3,
}:
python3.pkgs.buildPythonApplication {
  pname = "immich-machine-learning";
  inherit (immich) version;
  src = "${src}/machine-learning";
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'

    # Allow immich to use pydantic v2
    substituteInPlace app/schemas.py --replace-fail 'pydantic' 'pydantic.v1'
    substituteInPlace app/main.py --replace-fail 'pydantic' 'pydantic.v1'
    substituteInPlace app/config.py \
      --replace-fail 'pydantic' 'pydantic.v1'
  '';

  pythonRelaxDeps = [
    "setuptools"
    "pydantic"
  ];
  pythonRemoveDeps = [ "opencv-python-headless" ];

  build-system = with python3.pkgs; [
    poetry-core
    cython
  ];

  dependencies =
    with python3.pkgs;
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

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share
    cp log_conf.json $out/share

    cp -r ann $out/${python3.sitePackages}/

    makeWrapper ${lib.getExe python3.pkgs.gunicorn} $out/bin/machine-learning \
      --prefix PYTHONPATH : "$out/${python3.sitePackages}:$PYTHONPATH" \
      --set-default MACHINE_LEARNING_WORKERS 1 \
      --set-default MACHINE_LEARNING_WORKER_TIMEOUT 120 \
      --set-default MACHINE_LEARNING_CACHE_FOLDER /var/cache/immich \
      --set-default IMMICH_HOST 127.0.0.1 \
      --set-default IMMICH_PORT 3003 \
      --add-flags "app.main:app -k app.config.CustomUvicornWorker \
        -w \"\$MACHINE_LEARNING_WORKERS\" \
        -b \"\$IMMICH_HOST:\$IMMICH_PORT\" \
        -t \"\$MACHINE_LEARNING_WORKER_TIMEOUT\"
        --log-config-json $out/share/log_conf.json"
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
