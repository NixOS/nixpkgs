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
  pyprojectVersionPatchHook,
  netbox,
}:
buildPythonPackage (finalAttrs: {
  pname = "netboxlabs-diode-netbox-plugin";
  version = "1.18.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "netboxlabs";
    repo = "diode-netbox-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cayva6+4pg1gJrqHwbamHLcnw5Azc8mLSUv6kmduucg=";
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

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [ netbox ];

  preFixup = ''
    export PYTHONPATH=${netbox}/opt/netbox/netbox:$PYTHONPATH
  '';

  dontUsePythonImportsCheck = python.pythonVersion != netbox.python.pythonVersion;

  pythonImportsCheck = [ "netbox_diode_plugin" ];

  passthru.pluginName = "netbox_diode_plugin";

  meta = {
    description = "NetBox Diode plugin is a required component of the Diode ingestion service";
    homepage = "https://github.com/netboxlabs/diode-netbox-plugin";
    changelog = "https://github.com/netboxlabs/diode-netbox-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.netboxLimitedUse;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
