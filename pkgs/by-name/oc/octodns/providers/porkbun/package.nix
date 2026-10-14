{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  octodns,
  oinker,
  pytest-cov-stub,
  pytest-randomly,
  pytestCheckHook,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "octodns-porkbun";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "major";
    repo = "octodns-porkbun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RDYP0hF8nnG8lzeaWxfLXiG+mNDt+wf7yDfNMl6kDE0=";
  };

  build-system = [ uv-build ];

  dependencies = [
    octodns
    oinker
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-randomly
    pytestCheckHook
  ];

  pythonImportsCheck = [ "octodns_porkbun" ];

  meta = {
    description = "Porkbun DNS provider for octoDNS";
    homepage = "https://github.com/major/octodns-porkbun";
    changelog = "https://github.com/major/octodns-porkbun/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
    teams = [ lib.teams.octodns ];
  };
})
