{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-contextmenus";
  version = "1.4.14";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PieterL75";
    repo = "netbox_contextmenus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YqyxZaHKXhMLDdBTAAKQsCBBSXikxBgcOvXEfa6f+0Y=";
  };

  build-system = [ setuptools ];

  # pythonImportsCheck fails due to improperly configured django app

  meta = {
    description = "Netbox plugin to add context buttons to the links, making navigating less clicky";
    homepage = "https://github.com/PieterL75/netbox_contextmenus/";
    changelog = "https://github.com/PieterL75/netbox_contextmenus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
