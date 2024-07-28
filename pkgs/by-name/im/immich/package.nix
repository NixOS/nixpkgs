{
  lib,
  pkgs,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  nodejs,
  runCommand,
  nixosTests,
  # build-time deps
  pkg-config,
  makeWrapper,
  cmake,
  curl,
  cacert,
  unzip,
  # runtime deps
  ffmpeg-full, # immich requires at least webp encoder from ffmpeg-full
  imagemagick,
  libraw,
  libheif,
  vips,
  perl,
}:
let
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  meta = with lib; {
    description = "Self-hosted photo and video backup solution";
    homepage = "https://immich.app/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ jvanbruegge ];
    inherit (nodejs.meta) platforms;
  };

  buildLock = {
    sources =
      builtins.map
        (p: {
          name = p.pname;
          inherit (p) version;
          inherit (p.src) rev;
        })
        [
          imagemagick
          libheif
          libraw
        ];

    packages = [ ];
  };

  # The geodata website is not versioned, so we use the internet archive
  geodata =
    runCommand "immich-geodata"
      {
        outputHash = "sha256-imqSfzXaEMNo9T9tZr80sr/89n19kiFc8qwidFzRUaY=";
        outputHashMode = "recursive";
        nativeBuildInputs = [ cacert ];

        meta.license = lib.licenses.cc-by-40;
      }
      ''
        mkdir $out
        url="https://web.archive.org/web/20240724153050/http://download.geonames.org/export/dump"
        ${lib.getExe curl} -Lo ./cities500.zip "$url/cities500.zip"
        ${lib.getExe curl} -Lo $out/admin1CodesASCII.txt "$url/admin1CodesASCII.txt"
        ${lib.getExe curl} -Lo $out/admin2Codes.txt "$url/admin2Codes.txt"
        ${lib.getExe curl} -Lo $out/ne_10m_admin_0_countries.geojson \
          https://raw.githubusercontent.com/nvkelso/natural-earth-vector/v5.1.2/geojson/ne_10m_admin_0_countries.geojson

        ${lib.getExe unzip} ./cities500.zip -d $out/
        echo "2024-07-24T15:30:50Z" > $out/geodata-date.txt
      '';

  src = fetchFromGitHub {
    owner = "immich-app";
    repo = "immich";
    rev = "v${version}";
    inherit (sources) hash;
  };

  openapi = buildNpmPackage' {
    pname = "immich-openapi-sdk";
    inherit version;
    src = "${src}/open-api/typescript-sdk";
    inherit (sources.components."open-api/typescript-sdk") npmDepsHash;

    installPhase = ''
      runHook preInstall

      npm config delete cache
      npm prune --omit=dev --omit=optional

      mkdir -p $out
      mv package.json package-lock.json node_modules build $out/

      runHook postInstall
    '';
  };

  cli = buildNpmPackage' {
    pname = "immich-cli";
    inherit version;
    src = "${src}/cli";
    inherit (sources.components.cli) npmDepsHash;

    nativeBuildInputs = [ makeWrapper ];

    preBuild = ''
      rm node_modules/@immich/sdk
      ln -s ${openapi} node_modules/@immich/sdk
      # Rollup does not find the dependency otherwise
      ln -s node_modules/@immich/sdk/node_modules/@oazapfts node_modules/
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv package.json package-lock.json node_modules dist $out/

      ls $out/dist

      makeWrapper ${lib.getExe nodejs} $out/bin/immich --add-flags $out/dist/index.js

      runHook postInstall
    '';

    meta = {
      inherit (meta)
        description
        homepage
        license
        maintainers
        platforms
        ;
      mainProgram = "immich";
    };
  };

  web = buildNpmPackage' {
    pname = "immich-web";
    inherit version;
    src = "${src}/web";
    inherit (sources.components.web) npmDepsHash;

    inherit (cli) preBuild;

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };

  machine-learning = python3.pkgs.buildPythonApplication {
    pname = "immich-machine-learning";
    inherit version;
    src = "${src}/machine-learning";
    pyproject = true;

    postPatch = ''
      substituteInPlace pyproject.toml --replace-fail 'fastapi-slim' 'fastapi'

      # Allow immich to use pydantic v2
      substituteInPlace app/schemas.py --replace-fail 'pydantic' 'pydantic.v1'
      substituteInPlace app/main.py --replace-fail 'pydantic' 'pydantic.v1'
      substituteInPlace app/config.py \
        --replace-fail 'pydantic' 'pydantic.v1' \
        --replace-fail '/cache' '/var/cache/immich'
    '';

    pythonRelaxDeps = [
      "setuptools"
      "pydantic"
    ];
    pythonRemoveDeps = [ "opencv-python-headless" ];

    nativeBuildInputs = with python3.pkgs; [
      pythonRelaxDepsHook
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
      ++ python3.pkgs.uvicorn.optional-dependencies.standard;

    doCheck = false;

    postInstall = ''
      mkdir -p $out/share
      cp log_conf.json $out/share

      cp -r ann $out/${python3.sitePackages}/

      makeWrapper ${python3.pkgs.gunicorn}/bin/gunicorn $out/bin/machine-learning \
        --prefix PYTHONPATH : "$out/${python3.sitePackages}:$PYTHONPATH" \
        --set-default MACHINE_LEARNING_WORKERS 1 \
        --set-default MACHINE_LEARNING_WORKER_TIMEOUT 120 \
        --set-default IMMICH_HOST 127.0.0.1 \
        --set-default IMMICH_PORT 3003 \
        --add-flags "app.main:app -k app.config.CustomUvicornWorker \
          -w \"\$MACHINE_LEARNING_WORKERS\" \
          -b \"\$IMMICH_HOST:\$IMMICH_PORT\" \
          -t \"\$MACHINE_LEARNING_WORKER_TIMEOUT\"
          --log-config-json $out/share/log_conf.json"
    '';

    meta = {
      inherit (meta)
        description
        homepage
        license
        maintainers
        platforms
        ;
      mainProgram = "machine-learning";
    };
  };
in
buildNpmPackage' {
  pname = "immich";
  inherit version;
  src = "${src}/server";
  inherit (sources.components.server) npmDepsHash;

  nativeBuildInputs = [
    pkg-config
    python3
    makeWrapper
  ];

  buildInputs = [
    ffmpeg-full
    imagemagick
    libraw
    libheif
    vips # Required for sharp
  ];

  # Required because vips tries to write to the cache dir
  makeCacheWritable = true;

  installPhase = ''
    runHook preInstall

    npm config delete cache
    npm prune --omit=dev

    mkdir -p $out/build
    mv package.json package-lock.json node_modules dist resources $out/
    ln -s ${web} $out/build/www
    ln -s ${geodata} $out/build/geodata

    echo '${builtins.toJSON buildLock}' > $out/build/build-lock.json

    makeWrapper ${lib.getExe nodejs} $out/bin/admin-cli --add-flags $out/dist/main --add-flags cli
    makeWrapper ${lib.getExe nodejs} $out/bin/server --add-flags $out/dist/main --chdir $out \
      --set IMMICH_BUILD_DATA $out/build --set NODE_ENV production \
      --suffix PATH : "${
        lib.makeBinPath [
          perl
          ffmpeg-full
        ]
      }"

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) immich;
    };
    inherit
      cli
      web
      machine-learning
      geodata
      ;
    updateScript = ./update.sh;
  };

  meta = {
    inherit (meta)
      description
      homepage
      license
      maintainers
      platforms
      ;
    mainProgram = "server";
  };
}
