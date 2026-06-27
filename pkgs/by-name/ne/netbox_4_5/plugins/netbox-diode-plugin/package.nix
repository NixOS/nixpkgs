{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  brotli,
  certifi,
  grpcio,
  protobuf,
  python,
  netbox,
}:
buildPythonPackage (finalAttrs: {
  pname = "netbox-diode-plugin";
  version = "1.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "diode-netbox-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/HiZ9bSalZ5FtpJqvL+fRkm7kveCLnEWvTH2vdT54rc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    brotli
    certifi
    grpcio
    protobuf
  ];

  pythonRelaxDeps = [
    "certifi"
    "grpcio"
    "protobuf"
  ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_diode_plugin" ];

  passthru.pluginName = "netbox_diode_plugin";

  meta = {
    description = "NetBox plugin for NetBox for Diode";
    homepage = "https://netboxlabs.com/docs/diode/";
    changelog = "https://github.com/netboxlabs/diode-netbox-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.netboxLimitedUse;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
