{
  lib,
  python3Packages,
  fetchFromGitHub,
  bashate,
}:

python3Packages.buildPythonApplication rec {
  pname = "kolla";
  version = "20.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "kolla";
    tag = version;
    hash = "sha256-aqYEzBphzwB42Z0HmnCPQlV71dOi3yLKh+zL2dMTaB8=";
  };

  postPatch = ''
    substituteInPlace kolla/image/kolla_worker.py \
      --replace-fail "os.path.join(sys.prefix, 'share/kolla')," \
      "os.path.join(PROJECT_ROOT, '../../../share/kolla'),"

    sed -e 's/git_info = .*/git_info = "${version}"/' -i kolla/version.py
  '';

  pythonRelaxDeps = [
    "hacking"
  ];

  # fake version to make pbr.packaging happy
  env.PBR_VERSION = version;

  build-system = with python3Packages; [
    setuptools
    pbr
  ];

  dependencies = with python3Packages; [
    docker
    jinja2
    oslo-config
    gitpython
    podman
  ];

  postInstall = ''
    cp kolla/template/repos.yaml $out/${python3Packages.python.sitePackages}/kolla/template/
  '';

  nativeCheckInputs = with python3Packages; [
    testtools
    stestr
    oslotest
    hacking
    coverage
    bashate
  ];

  # Tests output a few exceptions but still succeed
  checkPhase = ''
    runHook preCheck
    stestr run -e <(echo "test_load_ok")
    runHook postCheck
  '';

  meta = with lib; {
    description = "Provides production-ready containers and deployment tools for operating OpenStack clouds";
    mainProgram = "kolla-build";
    homepage = "https://opendev.org/openstack/kolla";
    license = licenses.asl20;
    maintainers = [ maintainers.astro ];
    teams = [ teams.openstack ];
  };
}
