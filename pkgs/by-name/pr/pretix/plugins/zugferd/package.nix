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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-zugferd";
    rev = "v${version}";
    hash = "sha256-/efhp9B/cw/C3Bok8/E93dOrP9FHfaVZNSwC/j2lNuA=";
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

  meta = with lib; {
    description = "Annotate pretix' invoices with ZUGFeRD data";
    homepage = "https://github.com/pretix/pretix-zugferd";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
