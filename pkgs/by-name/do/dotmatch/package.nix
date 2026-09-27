{
  lib,
  fetchPypi,
  python3Packages,
  zlib,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dotmatch";
  version = "0.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xEGqr7aynbUVYNP8aMUqitAe0PCBWKiVRMHZNm8S/Og=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = [ python3Packages.tomli ];

  buildInputs = [ zlib ];

  pythonImportsCheck = [
    "assaycode"
    "dotmatch"
    "quickdna"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  postInstallCheck = ''
    test "$($out/bin/dotmatch dist ACGT AGGT)" = 1
  '';

  meta = {
    description = "Known-target short-DNA assignment from FASTQ";
    homepage = "https://github.com/dnncha/dotmatch";
    license = lib.licenses.asl20;
    mainProgram = "dotmatch";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ dnncha ];
  };
})
