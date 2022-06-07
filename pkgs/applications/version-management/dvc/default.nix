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
  version = "2.10.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-boaQSg0jajWQZKB5wvcP2musVR2/pifT4pU64Y5hiQ0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp-retry
    appdirs
    colorama
    configobj
    configobj
    dictdiffer
    diskcache
    distro
    dpath
    dvclive
    dvc-render
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
    toml
    tqdm
    typing-extensions
    voluptuous
    zc_lockfile
  ] ++ lib.optional enableGoogle [
    google-cloud-storage
  ] ++ lib.optional enableAWS [
    boto3
  ] ++ lib.optional enableAzure [
    azure-storage-blob
  ] ++ lib.optional enableSSH [
    paramiko
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "grandalf==0.6" "grandalf>=0.6" \
      --replace "scmrepo==0.0.19" "scmrepo"
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  # Tests require access to real cloud services
  doCheck = false;

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
  };
}
