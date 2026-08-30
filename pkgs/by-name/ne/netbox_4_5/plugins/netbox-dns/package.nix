{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-plugin-dns";
  version = "1.5.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "peteeckel";
    repo = "netbox-plugin-dns";
    tag = finalAttrs.version;
    hash = "sha256-9YMUrxqjyp9qixETAf/MpSTKO4HnItPH1qQ1MqGPcv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dnspython
  ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin for managing DNS data";
    homepage = "https://github.com/peteeckel/netbox-plugin-dns";
    changelog = "https://github.com/peteeckel/netbox-plugin-dns/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
