{
  lib,
  fetchFromGitHub,
  makeWrapper,
  python3,
  python3Packages,
  stdenvNoCC,
  nodejs_24,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
}:

let
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "opsmill";
    repo = "infrahub";
    tag = "infrahub-v${version}";
    hash = "sha256-icqTnPimDG2UaysLVqJ/AELXI/qFa1ZDFfiqeingpqI=";
  };

  schema-visualizer-src = fetchFromGitHub {
    owner = "opsmill";
    repo = "infrahub-schema-visualizer";
    rev = "f7d3cc5af409e9db7916947e33b887737a626d4d";
    hash = "sha256-tdKS+H9rUssbF3Pc0UECLELVMjbPIcRhuzosWXTFR9s=";
  };

  frontend = stdenvNoCC.mkDerivation (frontendFinalAttrs: {
    pname = "infrahub-frontend";
    inherit version src;
    sourceRoot = "${src.name}/frontend";

    postPatch = ''
      rm -rf packages/schema-visualizer
      cp -r --no-preserve=mode,ownership ${schema-visualizer-src} packages/schema-visualizer
      chmod -R u+w packages/schema-visualizer
    '';

    nativeBuildInputs = [
      nodejs_24
      pnpm_10
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit (frontendFinalAttrs)
        pname
        version
        src
        sourceRoot
        postPatch
        ;
      pnpm = pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-E28fPSe8J8ed/wixde5EzpgtpCJyWPlylpx6FDXyL4o=";
    };

    buildPhase = ''
      runHook preBuild
      pnpm --filter frontend build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r app/dist $out/dist
      runHook postInstall
    '';
  });
in
python3Packages.buildPythonPackage (finalAttrs: {
  pname = "infrahub-server";
  inherit version src;
  pyproject = true;

  build-system = [
    python3Packages.hatchling
    python3Packages.hatch-vcs
  ];
  dependencies = with python3Packages; [
    neo4j
    neo4j-rust-ext
    pydantic
    pydantic-settings
    pytest
    aio-pika
    structlog
    boto3
    email-validator
    redis
    hiredis
    typer
    click
    prefect
    prefect-redis
    ujson
    jinja2
    gitpython
    pyyaml
    tomli
    deepdiff
    httpx
    fastapi
    fastapi-storages
    graphene
    gunicorn
    prometheus-client
    lunr
    starlette-exporter
    python-multipart
    asgi-correlation-id
    bcrypt
    pyjwt
    uvicorn
    opentelemetry-instrumentation-aio-pika
    opentelemetry-instrumentation-fastapi
    grpcio
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-otlp-proto-http
    nats-py
    netaddr
    authlib
    aiodataloader
    fast-depends
    cachetools-async
    puremagic
    rich
    pyarrow
    numpy
    dulwich
    whenever
    netutils
    ariadne-codegen
    infrahub-sdk
  ];
  nativeBuildInputs = [
    makeWrapper
    python3Packages.pythonRelaxDepsHook
  ];
  pythonRelaxDeps = true;

  passthru.frontend = frontend;

  postInstall = ''
    pythonPath="${python3Packages.makePythonPath finalAttrs.propagatedBuildInputs}:$out/${python3.sitePackages}"
    makeWrapper ${lib.getExe python3Packages.gunicorn} $out/bin/gunicorn \
      --prefix PYTHONPATH : "$pythonPath" \
      --set INFRAHUB_FRONTEND_DIRECTORY ${frontend}
    makeWrapper ${lib.getExe python3Packages.prefect} $out/bin/prefect \
      --prefix PYTHONPATH : "$pythonPath"
    makeWrapper ${lib.getExe python3Packages.uvicorn} $out/bin/infrahub-prefect-server \
      --prefix PYTHONPATH : "$pythonPath" \
      --add-flags "infrahub.prefect_server.app:create_infrahub_prefect --factory"
  '';

  meta = {
    description = "Infrastructure catalog and source of truth built on a graph database";
    homepage = "https://github.com/opsmill/infrahub";
    changelog = "https://github.com/opsmill/infrahub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
