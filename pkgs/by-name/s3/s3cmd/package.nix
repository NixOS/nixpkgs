{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "s3cmd";
  version = "2.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "s3tools";
    repo = "s3cmd";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-cxwf6+9WFt3U7+JdKRgZxFElD+Dgf2P2VyejHVoiDJk=";
  };

  dependencies = with python3Packages; [
    python-magic
    python-dateutil
  ];

  build-system = with python3Packages; [ setuptools ];

  pythonImportsCheck = [ "S3" ];

  meta = {
    homepage = "https://s3tools.org/s3cmd";
    description = "Command line tool for managing Amazon S3 and CloudFront services";
    mainProgram = "s3cmd";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})
