{
  lib,
  async-timeout,
  asyncstdlib,
  attrs,
  buildPythonPackage,
  defusedxml,
  fetchFromGitHub,
  fetchpatch2,
  ftfy,
  httpx,
  netifaces,
  pytest-asyncio,
  pytestCheckHook,
  pytest-httpx,
  pytest-timeout,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "denonavr";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ol-iver";
    repo = "denonavr";
    rev = "refs/tags/${version}";
    hash = "sha256-/K2pz3B4H205grDeuMWZmEeA4wJqKhP0XdpmbqFguTM=";
  };

  patches = [
    (fetchpatch2 {
      name = "pytest-httpx-compat.patch";
      url = "https://github.com/ol-iver/denonavr/commit/5320aadae91135a8c208c83d82688ddf26eb6498.patch";
      hash = "sha256-F9R5GJ1XK3lHWLY+OgzKu3+xCosK3nX4EII9J1jhlys=";
    })
  ];

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ setuptools ];

  dependencies = [
    asyncstdlib
    attrs
    defusedxml
    ftfy
    httpx
    netifaces
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-httpx
    pytest-timeout
  ];

  pythonImportsCheck = [ "denonavr" ];

  meta = with lib; {
    description = "Automation Library for Denon AVR receivers";
    homepage = "https://github.com/ol-iver/denonavr";
    changelog = "https://github.com/ol-iver/denonavr/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens ];
  };
}
