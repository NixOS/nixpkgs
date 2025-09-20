{
  lib,
  buildPythonApplication ? python3Packages.buildPythonApplication,
  fetchFromGitHub,
  setuptools ? python3Packages.setuptools,
  setuptools-scm ? python3Packages.setuptools-scm,
  beautifulsoup4 ? python3Packages.beautifulsoup4,
  colorama ? python3Packages.colorama,
  conda-souschef ? python3Packages.conda-souschef,
  pip ? python3Packages.pip,
  pkginfo ? python3Packages.pkginfo,
  progressbar2 ? python3Packages.progressbar2,
  rapidfuzz ? python3Packages.rapidfuzz,
  requests ? python3Packages.requests,
  ruamel-yaml ? python3Packages.ruamel-yaml,
  ruamel-yaml-jinja2 ? python3Packages.ruamel-yaml-jinja2,
  stdlib-list ? python3Packages.stdlib-list,
  tomli-w ? python3Packages.tomli-w,
  nix-update-script,

  python3Packages,
}:

buildPythonApplication rec {
  pname = "grayskull";
  version = "2.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "conda";
    repo = "grayskull";
    tag = "v${version}";
    hash = "sha256-94lt8WgOtossAxAbx+hRxR+o8D12LmetCi6RbH18R64=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];
  dependencies = [
    beautifulsoup4
    colorama
    conda-souschef
    pip
    pkginfo
    progressbar2
    rapidfuzz
    requests
    ruamel-yaml
    ruamel-yaml-jinja2
    stdlib-list
    tomli-w
  ];

  passthru.update-script = nix-update-script { };

  meta = {
    description = "Recipe generator for Conda";
    homepage = "https://conda.github.io/grayskull/";
    mainProgram = "grayskull";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
