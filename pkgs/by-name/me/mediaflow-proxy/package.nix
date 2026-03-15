{
  fetchFromGitHub,
  lib,
  nixosTests,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: rec {
  pname = "mediaflow-proxy";
  version = "2.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mhdzumair";
    repo = "mediaflow-proxy";
    tag = finalAttrs.version;
    hash = "sha256-pY9VoHQ72NejZYmFnikjT+1LD2rzT+xKkqDEkSU2NEk=";
  };

  dontWrapPythonPrograms = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    fastapi
    aiohttp
    aiohttp-socks
    tenacity
    xmltodict
    pydantic-settings
    gunicorn
    pycryptodome
    uvicorn
    tqdm
    aiofiles
    beautifulsoup4
    lxml
    psutil
    curl-cffi
    telethon
    cryptg
    redis
    av
  ];

  postInstall = ''
    makeWrapper ${lib.getExe python3Packages.gunicorn} "''${!outputBin}"/bin/mediaflow-proxy \
      --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:${python3Packages.makePythonPath dependencies}" \
      --set-default MEDIAFLOW_PROXY_WORKERS 1 \
      --set-default MEDIAFLOW_PROXY_WORKER_TIMEOUT 120 \
      --set-default MEDIAFLOW_PROXY_HOST "[::1]" \
      --set-default MEDIAFLOW_PROXY_PORT 8888 \
      --add-flags "mediaflow_proxy.main:app -k uvicorn.workers.UvicornWorker \
        -w \"\$MEDIAFLOW_PROXY_WORKERS\" \
        -b \"\$MEDIAFLOW_PROXY_HOST:\$MEDIAFLOW_PROXY_PORT\" \
        -t \"\$MEDIAFLOW_PROXY_WORKER_TIMEOUT\""
  '';

  passthru.tests = {
    # smoke-test = nixosTests.mediaflow-proxy;
  };

  meta = {
    description = "A high-performance proxy server for streaming media";
    homepage = "https://github.com/mhdzumair/mediaflow-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ diogotcorreia ];
    mainProgram = "mediaflow-proxy";
    platforms = lib.platforms.all;
  };
})
