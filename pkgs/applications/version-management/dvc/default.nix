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
  version = "3.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1kVc7+36rvIpoSinpyxMMs1/nhZrwv1pPWJsruFd1N8=";
  };

  pythonRelaxDeps = [
    "dvc-data"
    "platformdirs"
  ];

  postPatch = ''
    substituteInPlace dvc/analytics.py --replace 'enabled = not os.getenv(DVC_NO_ANALYTICS)' 'enabled = False'
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    colorama
    configobj
    distro
    dpath
    dvc-data
    dvc-http
    dvc-render
    dvc-studio-client
    dvc-task
    flatten-dict
    flufl_lock
    funcy
    grandalf
    hydra-core
    iterative-telemetry
    networkx
    packaging
    pathspec
    platformdirs
    psutil
    pydot
    pygtrie
    pyparsing
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
  ] ++ lib.optionals enableGoogle [
    dvc-gs
  ] ++ lib.optionals enableAWS [
    dvc-s3
  ] ++ lib.optionals enableAzure [
    dvc-azure
  ] ++ lib.optionals enableSSH [
    dvc-ssh
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  # Tests require access to real cloud services
  doCheck = false;

  pythonImportsCheck = [ "dvc" "dvc.api" ];

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    changelog = "https://github.com/iterative/dvc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
  };
}
