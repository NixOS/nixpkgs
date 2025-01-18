{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "csvs-to-sqlite";
  version = "1.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = pname;
    rev = version;
    hash = "sha256-wV6htULG3lg2IhG2bXmc/9vjcK8/+WA7jm3iJu4ZoOE=";
  };

  patches = [
    # https://github.com/simonw/csvs-to-sqlite/pull/92
    (fetchpatch {
      name = "pandas2-compatibility-1.patch";
      url = "https://github.com/simonw/csvs-to-sqlite/commit/fcd5b9c7485bc7b95bf2ed9507f18a60728e0bcb.patch";
      hash = "sha256-ZmaNWxsqeNw5H5gAih66DLMmzmePD4no1B5mTf8aFvI=";
    })
    (fetchpatch {
      name = "pandas2-compatibility-2.patch";
      url = "https://github.com/simonw/csvs-to-sqlite/commit/3d190aa44e8d3a66a9a3ca5dc11c6fe46da024df.patch";
      hash = "sha256-uYUH0Mhn6LIf+AHcn6WuCo5zFuSNWOZBM+AoqkmMnSI=";
    })
  ];

  nativeBuildInputs = [
  ];

  propagatedBuildInputs = [
    click
    dateparser
    pandas
    py-lru-cache
    six
  ];

  pythonRelaxDeps = [
    "click"
  ];

  nativeCheckInputs = [
    cogapp
    pytestCheckHook
  ];

  disabledTests = [
    # Test needs to be adjusted for click >= 8.
    "test_if_cog_needs_to_be_run"
  ];

  meta = with lib; {
    description = "Convert CSV files into a SQLite database";
    homepage = "https://github.com/simonw/csvs-to-sqlite";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
    mainProgram = "csvs-to-sqlite";
  };
}
