{
  lib,
  fetchFromGitHub,
  python3Packages,
  nebula,
}:

python3Packages.buildPythonApplication rec {
  pname = "nebula-lighthouse-service";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "manuels";
    repo = "nebula-lighthouse-service";
    tag = "v${version}";
    hash = "sha256-cRwmOGuPEYlURVbaf9AwaSmhvUzzZvATv5RGPUztnbY=";
  };

  postPatch = ''
    substituteInPlace nebula_lighthouse_service/webservice.py \
      --replace-fail 'from pydantic' 'from pydantic.v1'
    substituteInPlace setup.py \
      --replace-fail 'pydantic==1.10.21' 'pydantic>=2' \
      --replace-fail 'fastapi==0.116.1' 'fastapi' \
      --replace-fail 'PyYAML==6.0.2' 'PyYAML' \
      --replace-fail 'uvicorn==0.35.0' 'uvicorn' \
      --replace-fail 'python-multipart==0.0.20' 'python-multipart'
  '';
  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    fastapi
    pyyaml
    uvicorn
    pydantic
    python-multipart
    nebula
  ];

  pythonImportsCheck = [
    "nebula_lighthouse_service"
  ];

  meta = {
    description = "Public Nebula VPN Lighthouse Service, you can use it in case you don’t have a publicly accessible server to run your own Nebula Lighthouse";
    homepage = "https://github.com/manuels/nebula-lighthouse-service";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bloominstrong
    ];
    mainProgram = "nebula-lighthouse-service";
  };
}
