{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pillow,
  qrcode,
  psycopg2,

  # nativeCheckInputs
  django,
  netaddr,
  netbox,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "netbox-qrcode";
  version = "0.0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netbox-community";
    repo = "netbox-qrcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A4qjpbfTULzS0UchUN9eX8jZmwoX/ej/18L/YAB8dKA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    qrcode
    pillow
  ];

  nativeCheckInputs = [
    django
    netaddr
    netbox
    psycopg2 # not specified in pyproject.toml, but required at import time
  ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;
  pythonImportsCheck = [ "netbox_qrcode" ];

  passthru.pluginName = "netbox_qrcode";

  meta = {
    description = "Netbox plugin for generate QR codes for objects: Rack, Device, Cable";
    homepage = "https://github.com/netbox-community/netbox-qrcode";
    changelog = "https://github.com/netbox-community/netbox-qrcode/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
