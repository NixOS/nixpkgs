{
  lib,
  buildPythonPackage,
  cliff,
  fetchPypi,
  iso8601,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  prettytable,
  python-swiftclient,
  pythonOlder,
  pyyaml,
  requests,
  requests-mock,
  setuptools,
  sphinxHook,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-heatclient";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ozpv4yyu8lmWmKg2iGMMN8IJ29zr87Gj73dn5QMgifI=";
  };

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    cliff
    iso8601
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    pbr
    prettytable
    python-swiftclient
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    stestr
    testscenarios
    requests-mock
  ];

  checkPhase = ''
    runHook preCheck

    stestr run -e <(echo "
      heatclient.tests.unit.test_common_http.HttpClientTest.test_get_system_ca_file
      heatclient.tests.unit.test_deployment_utils.TempURLSignalTest.test_create_temp_url
    ")

    runHook postCheck
  '';

  pythonImportsCheck = [ "heatclient" ];

  meta = with lib; {
    description = "Library for Heat built on the Heat orchestration API";
    mainProgram = "heat";
    homepage = "https://github.com/openstack/python-heatclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
