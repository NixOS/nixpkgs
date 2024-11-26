{
  lib,
  buildPythonPackage,
  clickhouse-cityhash,
  cython,
  fetchFromGitHub,
  freezegun,
  lz4,
  mock,
  pytestCheckHook,
  pytest-xdist,
  pytz,
  setuptools,
  tzlocal,
  zstd,
}:

buildPythonPackage rec {
  pname = "clickhouse-driver";
  version = "0.2.7";
  format = "setuptools";

  # pypi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "mymarilyn";
    repo = "clickhouse-driver";
    rev = version;
    hash = "sha256-l0YHWY25PMHgZG/sAZjtGhwmcxWdA8k96zlm9hbKcek=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    clickhouse-cityhash
    lz4
    pytz
    tzlocal
    zstd
  ];

  nativeCheckInputs = [
    freezegun
    mock
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lz4<=3.0.1" "lz4<=4"
  '';

  # remove source to prevent pytest testing source instead of the build artifacts
  # (the source doesn't contain the extension modules)
  preCheck = ''
    rm -rf clickhouse_driver
  '';

  # some test in test_buffered_reader.py doesn't seem to return
  disabledTestPaths = [ "tests/test_buffered_reader.py" ];

  # most tests require `clickhouse`
  # TODO: enable tests after `clickhouse` unbroken
  doCheck = false;

  pythonImportsCheck = [ "clickhouse_driver" ];

  meta = with lib; {
    description = "Python driver with native interface for ClickHouse";
    homepage = "https://github.com/mymarilyn/clickhouse-driver";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
