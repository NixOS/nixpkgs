{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "s3bro";
  version = "2.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+OqcLbXilbY4h/zRAkvRd8taVIOPyiScOAcDyPZ4RUw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    boto3
    botocore
    click
    termcolor
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "use_2to3=True," ""
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "s3bro"
  ];

  meta = with lib; {
    description = "S3 CLI tool";
    mainProgram = "s3bro";
    homepage = "https://github.com/rsavordelli/s3bro";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
