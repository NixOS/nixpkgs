{
  lib,
  aiohttp-apispec,
  aiohttp,
  apispec,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fetchPypi,
  ipv8-rust-tunnels,
  libnacl,
  marshmallow,
  packaging,
  pyasn1,
  pyopenssl,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyipv8";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tribler";
    repo = "py-ipv8";
    tag = finalAttrs.version;
    hash = "sha256-TrtsdpXmqC4qcKLh/iwwsLEky3md8jBX78zrP6SEpaA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiohttp-apispec
    apispec
    cryptography
    ipv8-rust-tunnels
    libnacl
    marshmallow
    packaging
    pyasn1
    pyopenssl
    typing-extensions
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # No longer exposes the sockname attribute
    "ipv8/test/REST/"
  ];

  pythonImportsCheck = [ "ipv8" ];

  meta = {
    description = "Python implementation of Tribler's IPv8 p2p-networking layer";
    homepage = "https://github.com/Tribler/py-ipv8";
    changelog = "https://github.com/Tribler/py-ipv8/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
})
