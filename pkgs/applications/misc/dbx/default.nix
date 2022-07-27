{ buildPythonPackage
, fetchFromGitHub
, databricks-cli
, scipy
, pathpy
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
, lib
}:

buildPythonPackage rec {
  pname = "dbx";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "databrickslabs";
    repo = "dbx";
    rev = "v${version}";
    sha256 = "gd466hhyTfPZwC3B3LlydRrkDtfzjY7SvTKy13HDFG8=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf==4.21.1" "protobuf>=3.19.4"
  '';

  propagatedBuildInputs = [
    databricks-cli
    scipy
    pathpy
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
  ];

  disabledTests = [
    # require a HOME for cookiecutter
    "test_configure"
    "test_datafactory_deploy"
    "test_deploy_incorrect_artifact_location"
    "test_deploy_listed_jobs"
    "test_deploy_multitask_json"
    "test_deploy_multitask_yaml"
    "test_deploy_non_existent_env"
    "test_deploy_path_adjustment_json"
    "test_deploy_path_adjustment_yaml"
    "test_deploy_with_jobs"
    "test_deploy_with_requirements_and_branch"
    "test_deployment_with_bad_env_variable"
    "test_update_job_negative"
    "test_update_job_positive"
    "test_with_permissions"
    "test_write_specs_to_file"
    "test_awake_cluster"
    "test_execute"
    "test_preprocess_cluster_args"
    "test_launch"
    "test_launch_run_submit"
    "test_launch_with_parameters"
    "test_no_runs"
    "test_no_runs_run_submit"
    "test_payload_keys"
    "test_trace_runs"
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
