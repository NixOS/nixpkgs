{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  octodns,
  oinker,
}:
buildPythonPackage (finalAttrs: {
  pname = "octodns-porkbun";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "major";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-RDYP0hF8nnG8lzeaWxfLXiG+mNDt+wf7yDfNMl6kDE0=";
  };

  build-system = [ uv-build ];

  dependencies = [
    octodns
    oinker
  ];

  pythonImportsCheck = [ (lib.replaceStrings [ "-" ] [ "_" ] finalAttrs.pname) ];

  meta = {
    description = "Porkbun DNS provider for octoDNS";
    homepage = "https://github.com/major/${finalAttrs.pname}";
    changelog = "https://github.com/major/${finalAttrs.pname}/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
