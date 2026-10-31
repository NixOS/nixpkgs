{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:
buildPythonPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "netbox-plugin-dns";
  version = "1.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "peteeckel";
    repo = "netbox-plugin-dns";
    tag = finalAttrs.version;
    hash = "sha256-SfBV76A7v2mF16Xmkjojy7BrqAcPKczstXb6tyuZBPs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
  ];

  # pythonImportsCheck fails due to improperly configured django app

  passthru.pluginName = "netbox_dns";

  meta = {
    description = "Netbox plugin for managing DNS data";
    homepage = "https://github.com/peteeckel/netbox-plugin-dns";
    changelog = "https://github.com/peteeckel/netbox-plugin-dns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
