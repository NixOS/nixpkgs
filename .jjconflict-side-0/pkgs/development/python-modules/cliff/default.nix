{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  autopage,
  cmd2_4,
  openstackdocstheme,
  pbr,
  prettytable,
  pyyaml,
  stevedore,
  sphinxHook,
  callPackage,
}:

buildPythonPackage (finalAttrs: {
  pname = "cliff";
  version = "4.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "cliff";
    tag = finalAttrs.version;
    hash = "sha256-zHUWBNdfekEpAqvdY8K9uyFcJYYKB4Z8eAjR3O8080U=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include cliff *" > MANIFEST.in
  '';

  build-system = [
    openstackdocstheme
    pbr
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
    autopage
    cmd2_4
    prettytable
    pyyaml
    stevedore
  ];

  # check in passthru.tests.pytest to escape infinite recursion with stestr
  doCheck = false;

  pythonImportsCheck = [
    "cliff"
    "cliff.formatters"
  ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = {
    description = "Command Line Interface Formulation Framework";
    homepage = "https://github.com/openstack/cliff";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
