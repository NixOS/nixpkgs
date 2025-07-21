{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fierce";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mschwager";
    repo = "fierce";
    tag = version;
    sha256 = "sha256-y5ZSDJCTqslU78kXGyk6DajBpX7xz1CVmbhYerHmyis=";
  };

  pythonRelaxDeps = [ "dnspython" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [ dnspython ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "fierce" ];

  meta = {
    description = "DNS reconnaissance tool for locating non-contiguous IP space";
    homepage = "https://github.com/mschwager/fierce";
    changelog = "https://github.com/mschwager/fierce/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ c0bw3b ];
    mainProgram = "fierce";
  };
}
