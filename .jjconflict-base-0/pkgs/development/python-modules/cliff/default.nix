{
  lib,
  buildPythonPackage,
  fetchPypi,
  autopage,
  cmd2,
  importlib-metadata,
  openstackdocstheme,
  pbr,
  prettytable,
  pyparsing,
  pyyaml,
  setuptools,
  stevedore,
  sphinxHook,
  callPackage,
}:

buildPythonPackage rec {
  pname = "cliff";
  version = "4.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bKRfjfUZu8ByLGEEnee35EKkZfp/P1Urltc1+ib9WyY=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    openstackdocstheme
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    autopage
    cmd2
    importlib-metadata
    pbr
    prettytable
    pyparsing
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [ "cliff" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
