{
  lib,
  python311Packages,
  fetchFromGitHub,
  bashate,
}:

let
  pythonPackages = python311Packages;
in
pythonPackages.buildPythonApplication rec {
  pname = "kolla";
  version = "18.1.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "kolla";
    hash = "sha256-jLD6ILihymQlWkkpGYC4OX8BKLpQurAK6Y5Xpju+QAI=";
    rev = version;
  };

  postPatch = ''
    substituteInPlace kolla/image/kolla_worker.py \
      --replace-fail "os.path.join(sys.prefix, 'share/kolla')," \
      "os.path.join(PROJECT_ROOT, '../../../share/kolla'),"

    substituteInPlace test-requirements.txt \
      --replace-fail "hacking>=3.0.1,<3.1.0" "hacking"

    sed -e 's/git_info = .*/git_info = "${version}"/' -i kolla/version.py
  '';

  # fake version to make pbr.packaging happy
  env.PBR_VERSION = version;

  build-system = with pythonPackages; [
    setuptools
    pbr
  ];

  dependencies = with pythonPackages; [
    docker
    jinja2
    oslo-config
    gitpython
    podman
  ];

  postInstall = ''
    cp kolla/template/repos.yaml $out/${pythonPackages.python.sitePackages}/kolla/template/
  '';

  nativeCheckInputs = with pythonPackages; [
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
    stestr run
    runHook postCheck
  '';

  meta = with lib; {
    description = "Provides production-ready containers and deployment tools for operating OpenStack clouds";
    mainProgram = "kolla-build";
    homepage = "https://opendev.org/openstack/kolla";
    license = licenses.asl20;
    maintainers = teams.openstack.members ++ [ maintainers.astro ];
  };
}
