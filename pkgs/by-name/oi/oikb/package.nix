{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "oikb";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "oikb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/aT69TnOwNKi3cJdPzNch22jllRloe9TIVf7RfTXN80=";
  };

  build-system = with python3Packages; [
    uv-build
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build>=0.8.0,<0.9"' '"uv_build"'
  '';

  dependencies = with python3Packages; [
    click
    croniter
    httpx
    prometheus-client
    pyyaml
    rich
    watchdog
    fastapi
    uvicorn
    # uvicorn[standard] extras from the Dockerfile
    httptools
    uvloop
    watchfiles
    websockets
    python-dotenv
  ];

  # Matches [project.optional-dependencies] in pyproject.toml.
  # Not installed by default: pull in what you need via
  # oikb.optional-dependencies.<name> when overriding, e.g.:
  #   oikb.overridePythonAttrs (old: {
  #     dependencies = old.dependencies ++ oikb.optional-dependencies.s3;
  #   })
  passthru.optional-dependencies = with python3Packages; {
    s3 = [ boto3 ];
    r2 = [ boto3 ];
    gcs = [ google-cloud-storage ];
    azure = [ azure-storage-blob ];
    dropbox = [ dropbox ];
    gdrive = [
      google-api-python-client
      google-auth
    ];
    gmail = [
      google-api-python-client
      google-auth
    ];
    gsites = [
      google-api-python-client
      google-auth
    ];
    web = [ beautifulsoup4 ];
    oracle = [ oci ];
    sharepoint-cert = [
      cryptography
      pyjwt
    ];
  };

  # The upstream test suite hits network / external services (Confluence,
  # Slack, S3, ...) via respx-mocked httpx clients; skip to keep the
  # build hermetic
  doCheck = false;

  pythonImportsCheck = [ "oikb" ];

  meta = with lib; {
    description = "Sync anything to Open WebUI Knowledge Bases";
    homepage = "https://github.com/open-webui/oikb";
    license = licenses.mit;
    mainProgram = "oikb";
    maintainers = with lib.maintainers; [ gaelj ];
  };
})
