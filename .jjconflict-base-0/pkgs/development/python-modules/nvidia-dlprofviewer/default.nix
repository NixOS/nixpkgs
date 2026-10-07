{
  lib,
  buildPythonPackage,
  fetchurl,
  autoAddDriverRunpath,
  autoPatchelfHook,
  django,
  gunicorn,
  setuptools,
  sqlite,
  uvicorn,
  whitenoise,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvidia-dlprofviewer";
  version = "1.8.0";
  __structuredAttrs = true;
  format = "wheel";

  src = fetchurl {
    url = "https://pypi.nvidia.com/nvidia-dlprofviewer/nvidia_dlprofviewer-${finalAttrs.version}-py3-none-any.whl";
    hash = "sha256-KrfLZ6NdP31qfSfOBl8944ZE2xZ+kgjkyt+QPUblYVA=";
  };

  pythonImportsCheck = [
    "dlprofviewer"
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libnvidia-ml.so.1"
  ];

  propagatedBuildInputs = [
    django
    gunicorn
    setuptools
    sqlite
    uvicorn
    whitenoise
  ];

  pythonRelaxDeps = [
    "django"
  ];

  meta = {
    description = "NVIDIA DLProf Viewer";
    homepage = "https://docs.nvidia.com/deeplearning/frameworks/dlprof-user-guide/index.html";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
