{ buildPythonPackage
, fetchFromGitHub
, databricks-cli
, scipy
, path
, pathspec
, pydantic
, protobuf
, tqdm
, mlflow
, azure-identity
, ruamel-yaml
, emoji
, cookiecutter
, retry
, azure-mgmt-datafactory
, azure-mgmt-subscription
, pytestCheckHook
, pytest-asyncio
, pytest-timeout
, pytest-mock
, lib
, git
}:

buildPythonPackage rec {
  pname = "dbx";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    rev = "v${version}";
    sha256 = "sha256-Ou+VdHFVQzmsxJiyaeDd/+FqHvJZeNGB+OXyoagJwtk=";
  };

  propagatedBuildInputs = [
    databricks-cli
    scipy
    path
    pathspec
    pydantic
    protobuf
    tqdm
    mlflow
    azure-identity
    ruamel-yaml
    emoji
    cookiecutter
    retry
    azure-mgmt-datafactory
    azure-mgmt-subscription
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    pytest-mock
    git
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # fails because of dbfs CLI wrong call
    "test_dbfs_unknown_user"
    "test_dbfs_no_root"
  ];

  meta = with lib; {
    homepage = "https://github.com/databrickslabs/dbx";
    description = "CLI tool for advanced Databricks jobs management";
    license = licenses.databricks-dbx;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
