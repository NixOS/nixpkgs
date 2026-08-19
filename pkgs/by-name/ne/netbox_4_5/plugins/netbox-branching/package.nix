{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  netaddr,
  netbox,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-branching";
  version = "1.0.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "netbox-branching";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6UgV3h13v4B2107eMZWlOL1kLw6VOjntnPtZXUiw+A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    django
    netaddr
    netbox
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  pythonImportsCheck = [ "netbox_branching" ];

  passthru.pluginName = "netbox_branching";

  meta = {
    description = "Official NetBox Labs plugin that implements git-like branching functionality for NetBox";
    homepage = "https://github.com/netboxlabs/netbox-branching";
    changelog = "https://github.com/netboxlabs/netbox-branching/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.netboxLimitedUse;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
