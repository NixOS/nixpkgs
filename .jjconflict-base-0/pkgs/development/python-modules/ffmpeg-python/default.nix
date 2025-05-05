{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  fetchpatch2,
  setuptools,
  pytestCheckHook,
  pytest-mock,
  ffmpeg,
}:

buildPythonPackage {
  pname = "ffmpeg-python";
  version = "0.2.0-unstable-2022-07-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kkroening";
    repo = "ffmpeg-python";
    rev = "df129c7ba30aaa9ffffb81a48f53aa7253b0b4e6";
    hash = "sha256-jPiFhYRwfuS+vo6LsLw0+65NWy2A+B+EdC8SewZTRP4=";
  };

  patches = [
    (replaceVars ./ffmpeg-location.patch { inherit ffmpeg; })

    # Remove dependency on `future`
    # https://github.com/kkroening/ffmpeg-python/pull/795
    (fetchpatch2 {
      url = "https://github.com/kkroening/ffmpeg-python/commit/dce459d39ace25f03edbabdad1735064787568f7.patch?full_index=1";
      hash = "sha256-ZptCFplL88d0p2s741ymHiwyDsDGVFylBJ8FTrZDGMc=";
    })

    # Fix ffmpeg/tests/test_ffmpeg.py: test_pipe() (v1: ignore duplicate frames)
    # https://github.com/kkroening/ffmpeg-python/pull/726
    (fetchpatch2 {
      url = "https://github.com/kkroening/ffmpeg-python/commit/557ed8e81ff48c5931c9249ec4aae525347ecf85.patch?full_index=1";
      hash = "sha256-XrL9yLaBg1tu63OYZauEb/4Ghp2zHtiF6vB+1YYbv1Y=";
    })

    # Fix `test__probe` on FFmpeg 7
    # https://github.com/kkroening/ffmpeg-python/pull/848
    (fetchpatch2 {
      url = "https://github.com/kkroening/ffmpeg-python/commit/eeaa83398ba1d4e5b470196f7d4c7ca4ba9e8ddf.patch?full_index=1";
      hash = "sha256-/qxez4RF/RPRr9nA+wp+XB49L3VNgnMwMQhFD2NwijU=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "ffmpeg" ];

  meta = {
    description = "Python bindings for FFmpeg - with complex filtering support";
    homepage = "https://github.com/kkroening/ffmpeg-python";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.emily ];
  };
}
