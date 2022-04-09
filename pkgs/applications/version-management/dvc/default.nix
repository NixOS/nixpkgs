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
  version = "2.9.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = version;
    hash = "sha256-MviiA0ja1IaxMPlqu2dhIGBcdEXiEvBYnK9731dihMg=";
  };

  # make the patch apply
  prePatch = ''
    substituteInPlace setup.cfg \
      --replace "scmrepo==0.0.7" "scmrepo==0.0.10"
  '';

  patches = [
    ./dvc-daemon.patch
    (fetchpatch {
      url = "https://github.com/iterative/dvc/commit/ab54b5bdfcef3576b455a17670b8df27beb504ce.patch";
      sha256 = "sha256-wzMK6Br7/+d3EEGpfPuQ6Trj8IPfehdUvOvX3HZlS+o=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "grandalf==0.6" "grandalf>=0.6" \
      --replace "scmrepo==0.0.13" "scmrepo"
    substituteInPlace dvc/daemon.py \
      --subst-var-by dvc "$out/bin/dcv"
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    setuptools-scm-git-archive
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    aiohttp-retry
    colorama
    configobj
    configobj
    dictdiffer
    diskcache
    distro
    dpath
    flatten-dict
    flufl_lock
    funcy
    grandalf
    nanotime
    networkx
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

  # Tests require access to real cloud services
  doCheck = false;

  meta = with lib; {
    description = "Version Control System for Machine Learning Projects";
    homepage = "https://dvc.org";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai fab ];
  };
}
