{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
  django,
  drafthorse,
  ghostscript_headless,
}:

buildPythonPackage rec {
  pname = "pretix-zugferd";
  version = "2.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-zugferd";
    rev = "v${version}";
    hash = "sha256-C2Z/S3lEKmdi6fch/erjPc9evnKc69tBRTInXRgi24E=";
  };

  postPatch = ''
    substituteInPlace pretix_zugferd/invoice.py \
      --replace-fail 'fallback="gs"' 'fallback="${lib.getExe ghostscript_headless}"'
  '';

  pythonRelaxDeps = [ "drafthorse" ];

  build-system = [
    django
    pretix-plugin-build
    setuptools
  ];

  postBuild = ''
    make
  '';

  dependencies = [ drafthorse ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "pretix_zugferd" ];

  meta = {
    description = "Annotate pretix' invoices with ZUGFeRD data";
    homepage = "https://github.com/pretix/pretix-zugferd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
