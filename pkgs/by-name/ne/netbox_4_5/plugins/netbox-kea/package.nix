{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  requests,
  django,
  netaddr,
  psycopg2,
  python,
  netbox,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-kea";
  version = "2.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devon-mar";
    repo = "netbox-kea";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rlg2Ekyx/Z+Yby8QhQ8weH9oT/nVHO3Ca7K0jDn5iGs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    django
    netaddr
    psycopg2
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_kea" ];

  meta = {
    description = "NetBox plugin to manage Kea DHCP leases";
    homepage = "https://github.com/devon-mar/netbox-kea";
    changelog = "https://github.com/devon-mar/netbox-kea/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
