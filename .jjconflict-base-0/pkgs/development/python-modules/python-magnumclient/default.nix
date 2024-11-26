{
  lib,
  buildPythonPackage,
  cryptography,
  decorator,
  fetchFromGitHub,
  fixtures,
  keystoneauth1,
  openstackdocstheme,
  os-client-config,
  osc-lib,
  oslo-i18n,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  oslotest,
  osprofiler,
  pbr,
  prettytable,
  python-openstackclient,
  pythonOlder,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestr,
  testtools,
}:

buildPythonPackage rec {
  pname = "python-magnumclient";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "python-magnumclient";
    rev = "refs/tags/${version}";
    hash = "sha256-2JHI3CB/DSZZ4LXzL3PCUSmubTciUXtZkc5jpeEc4kk=";
  };

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    openstackdocstheme
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    cryptography
    decorator
    keystoneauth1
    os-client-config
    osc-lib
    oslo-i18n
    oslo-log
    oslo-serialization
    oslo-utils
    prettytable
    requests
  ];

  nativeCheckInputs = [
    fixtures
    python-openstackclient
    osprofiler
    oslotest
    requests-mock
    stestr
    testtools
  ];

  checkPhase = ''
    runHook preCheck
    stestr run
    runHook postCheck
  '';

  pythonImportsCheck = [ "magnumclient" ];

  meta = {
    homepage = "https://github.com/openstack/python-magnumclient";
    description = "Client library for OpenStack Magnum API";
    license = lib.licenses.asl20;
    mainProgram = "magnum";
    maintainers = lib.teams.openstack.members;
  };
}
