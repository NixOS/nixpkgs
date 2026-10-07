{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  grpcio-tools,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "smg-grpc-proto";
  version = "0.4.10";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    format = "setuptools";
    pname = "smg_grpc_proto";
    inherit (finalAttrs) version;
    hash = "sha256-VBVhjSUuWitD0du9LB6uMFdgBw3SRzUwgUCu0Gp0hr4=";
  };

  build-system = [
    grpcio-tools
    setuptools
  ];

  postInstall = ''
    find $out -name __pycache__ -type d | xargs rm -rv
  '';

  env.PYTHONDONTWRITEBYTECODE = 1;

  pythonImportsCheck = [ "smg_grpc_proto" ];

  # no tests
  doCheck = false;

  meta = {
    description = "SMG gRPC proto definitions for SGLang, vLLM, TRT-LLM, and MLX";
    homepage = "https://github.com/lightseekorg/smg/tree/main/crates/grpc_client/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
