{ lib
, fetchFromGitHub
, python3
, rsync
}:

python3.pkgs.buildPythonApplication rec {
  pname = "toil";
  version = "5.7.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DataBiosphere";
    repo = pname;
    rev = "refs/tags/releases/${version}";
    hash = "sha256-m+XvNyzd0ly2YqKhgxezgGaCXLs3CmupJMnp5RIZqNI=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "docker>=3.7.2, <6" "docker"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    addict
    dill
    docker
    enlighten
    psutil
    py-tes
    pypubsub
    python-dateutil
    pytz
    pyyaml
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    rsync
  ] ++ (with python3.pkgs; [
    boto
    botocore
    flask
    mypy-boto3-s3
    pytestCheckHook
    stubserver
  ]);

  pytestFlagsArray = [
    "src/toil/test"
  ];

  pythonImportsCheck = [
    "toil"
  ];

  disabledTestPaths = [
    # Tests are reaching their timeout
    "src/toil/test/docs/scriptsTest.py"
    "src/toil/test/jobStores/jobStoreTest.py"
    "src/toil/test/provisioners/aws/awsProvisionerTest.py"
    "src/toil/test/src"
    "src/toil/test/wdl"
    "src/toil/test/utils/utilsTest.py"
  ];

  disabledTests = [
    # Tests fail starting with 5.7.1
    "testServices"
    "testConcurrencyWithDisk"
    "testJobConcurrency"
    "testNestedResourcesDoNotBlock"
    "test_omp_threads"
    "testFileSingle"
    "testFileSingle10000"
    "testFileSingleCheckpoints"
    "testFileSingleNonCaching"
    "testFetchJobStoreFiles"
    "testFetchJobStoreFilesWSymlinks"
    "testJobStoreContents"
    "test_cwl_on_arm"
    "test_cwl_toil_kill"
  ];

  meta = with lib; {
    description = "Workflow engine written in pure Python";
    homepage = "https://toil.ucsc-cgl.org/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
