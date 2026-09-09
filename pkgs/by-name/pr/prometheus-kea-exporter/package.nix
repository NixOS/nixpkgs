{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kea-exporter";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "kea-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UwQYR01cBdPEUBhOo5TqwmptAvJpxln1OLU2boAFdn4=";
  };

  nativeBuildInputs = with python3Packages; [
    pdm-backend
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    prometheus-client
    requests
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.tests = {
    inherit (nixosTests) kea;
  };

  meta = {
    changelog = "https://github.com/mweinelt/kea-exporter/blob/v${finalAttrs.version}/HISTORY";
    description = "Export Kea Metrics in the Prometheus Exposition Format";
    mainProgram = "kea-exporter";
    homepage = "https://github.com/mweinelt/kea-exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
