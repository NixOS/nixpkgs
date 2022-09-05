{ lib
, python3
, fetchFromGitHub
, fetchpatch
, enableGoogle ? false
, enableAWS ? false
, enableAzure ? false
, enableSSH ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dvc";
  version = "2.17.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-2h+fy4KMxFrVtKJBtA1RmJDZv0OVm1BxO1akZzAw95Y=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "grandalf==0.6" "grandalf" \
      --replace "scmrepo==0.0.25" "scmrepo"
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp-retry
    appdirs
    colorama
    configobj
    dictdiffer
    diskcache
    distro
    dpath
    dvclive
    dvc-data
    dvc-render
    dvc-task
    flatten-dict
    flufl_lock
    funcy
    grandalf
    nanotime
    networkx
    packaging
    pathspec
    ply
    psutil
    pydot
    pygtrie
    pyparsing
    python-benedict
    requests
    rich
    ruamel-yaml
    scmrepo
    shortuuid
    shtab
    tabulate
    tomlkit
    tqdm
    typing-extensions
    voluptuous
    zc_lockfile
  ] ++ lib.optional enableGoogle [
    gcsfs
    google-cloud-storage
  ] ++ lib.optional enableAWS [
    aiobotocore
    boto3
    s3fs
  ] ++ lib.optional enableAzure [
    azure-identity
    knack
  ] ++ lib.optional enableSSH [
    bcrypt
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  # Tests require access to real cloud services
  doCheck = false;

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab anthonyroussel ];
  };
}
