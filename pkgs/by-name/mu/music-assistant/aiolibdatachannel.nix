{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  music-assistant,
  nanobind,
  ninja,
  openssl,
  pytest-asyncio,
  pytestCheckHook,
  scikit-build-core,
  setuptools-scm,
}:

buildPythonPackage {
  pname = "aiolibdatachannel";
  version = "2026.5.22-unstable-2026-07-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aiolibdatachannel";
    # feat/certpem-testdrive branch
    rev = "950e7f0fef33000e701bae48e4872913cebbcc9a";
    fetchSubmodules = true;
    hash = "sha256-y9tnlAQK+BAfXxy7sdNpxA5jOukMw+XkYEwPBj0JZC4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'setuptools-scm>=8,<9' 'setuptools-scm>=8' \
      --replace-fail 'dynamic = ["version"]' 'version = "2026.5.22"'
  '';

  env.AIOLIB_REQUIRE_NATIVE = "1";

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dontUseCmakeConfigure = true;

  build-system = [
    nanobind
    scikit-build-core
    setuptools-scm
  ];

  buildInputs = [
    openssl
  ];

  preCheck = ''
    rm -r aiolibdatachannel
  '';

  nativeCheckInputs = [
    openssl
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # require local networking
    "tests/test_async_iterators.py::test_ice_candidates_terminates_on_gathering_complete"
    "tests/test_events.py::test_events_emits_expected_types_during_gathering"
    "tests/test_loopback.py::test_loopback_datachannel"
  ];

  pythonImportsCheck = [ "aiolibdatachannel" ];

  meta = {
    description = "asyncio-friendly Python wrapper for libdatachannel (WebRTC Data Channels)";
    homepage = "https://github.com/music-assistant/aiolibdatachannel/tree/feat/certpem-testdrive";
    license = lib.licenses.mpl20;
    inherit (music-assistant.meta) maintainers;
  };
}
