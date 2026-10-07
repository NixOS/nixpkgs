{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pyyaml,

  # for passthru.tests
  asgi-csrf,
  connexion,
  fastapi,
  gradio,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-multipart";
  version = "0.0.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Kludex";
    repo = "python-multipart";
    tag = finalAttrs.version;
    hash = "sha256-zw6SHzbbjyRCGfUldxdki+wKwmTAgmd9ZAu/2zU+pFw=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "python_multipart" ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  passthru.tests = {
    inherit
      asgi-csrf
      connexion
      fastapi
      gradio
      starlette
      ;
  };

  meta = {
    changelog = "https://github.com/Kludex/python-multipart/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Streaming multipart parser for Python";
    homepage = "https://github.com/Kludex/python-multipart";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dotlambda
      ris
    ];
  };
})
