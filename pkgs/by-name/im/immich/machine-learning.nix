{
  lib,
  src,
  fetchFromGitHub,
  immich,
  python3,
  # Override Python packages using
  # self: super: { pkg = super.pkg.overridePythonAttrs (oldAttrs: { ... }); }
  # Applied after defaultOverrides
  packageOverrides ? self: super: { },
}:
let
  defaultOverrides = self: super: {
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

  python = python3.override {
    self = python;
    packageOverrides = lib.composeExtensions defaultOverrides packageOverrides;
  };
in
python.pkgs.buildPythonApplication {
  pname = "immich-machine-learning";
  inherit (immich) version;
  src = "${src}/machine-learning";
  pyproject = true;

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'
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

  doCheck = false;

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
