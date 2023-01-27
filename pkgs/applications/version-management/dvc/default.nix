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
  version = "2.43.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-FwJErwAVWFZ95wzBalGi9o+8BTtcGvnC9uQE1qTUaBs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "scmrepo==0.1.6" "scmrepo" \
      --replace "iterative-telemetry==0.0.6" "iterative-telemetry" \
      --replace "dvc-data==0.35.1" "dvc-data"
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    colorama
    configobj
    distro
    dpath
    dvclive
    dvc-data
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

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
    broken = true; # requires new python package: dvc-studio-client
  };
}
