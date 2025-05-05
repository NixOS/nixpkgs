{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
  webtest,
}:

buildPythonPackage rec {
  pname = "webtest-aiohttp";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = "webtest-aiohttp";
    tag = version;
    hash = "sha256-UuAz/k/Tnumupv3ybFR7PkYHwG3kH7M5oobZykEP+ao=";
  };

  patches = [
    (fetchpatch {
      name = "python311-compat.patch";
      url = "https://github.com/sloria/webtest-aiohttp/commit/64e5ab1867ea9ef87901bb2a1a6142566bffc90b.patch";
      hash = "sha256-OKJGajqJLFMkcbGmGfU9G5hCpJaj24Gs363sI0z7YZw=";
    })
  ];

  postPatch = ''
    substituteInPlace test_webtest_aiohttp.py \
      --replace-fail '(app, loop)' '(app, event_loop)' \
      --replace-fail 'WebTestApp(app, loop=loop)' 'WebTestApp(app, loop=event_loop)'
  '';

  build-system = [ setuptools ];

  dependencies = [ webtest ];

  nativeCheckInputs = [
    aiohttp
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "webtest_aiohttp" ];

  meta = with lib; {
    changelog = "https://github.com/sloria/webtest-aiohttp/blob/${src.rev}/CHANGELOG.rst";
    description = "Provides integration of WebTest with aiohttp.web applications";
    homepage = "https://github.com/sloria/webtest-aiohttp";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
