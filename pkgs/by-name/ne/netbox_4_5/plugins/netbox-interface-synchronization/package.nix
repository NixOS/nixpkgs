{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  netaddr,
  numpy,
  psycopg,
  requests,

  # tests
  netbox,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-interface-synchronization";
  version = "4.5.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetTech2001";
    repo = "netbox-interface-synchronization";
    tag = finalAttrs.version;
    hash = "sha256-DZ1xOfHop/rASWbBzVILVqvll94tQM7tRiSXwOo/QQI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    netaddr
    requests
    numpy
    psycopg # not specified in pyproject.toml, but required at import time
  ];

  # netbox is required for the pythonImportsCheck; plugin does not provide unit tests
  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_interface_synchronization" ];

  meta = {
    description = "Netbox plugin to compare and synchronize interfaces between devices and device types";
    homepage = "https://github.com/NetTech2001/netbox-interface-synchronization";
    changelog = "https://github.com/NetTech2001/netbox-interface-synchronization/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
