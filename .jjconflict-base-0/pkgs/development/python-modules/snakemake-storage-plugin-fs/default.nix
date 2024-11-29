{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  snakemake-interface-storage-plugins,
  snakemake-interface-common,
  sysrsync,
}:

buildPythonPackage rec {
  pname = "snakemake-storage-plugin-fs";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9A2W+V0d9K1Ei4WXqIZfIcOYsWgpGVP7P/ANy8jOGu0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    snakemake-interface-storage-plugins
    snakemake-interface-common
    sysrsync
  ];

  # The current tests are not worth dealing with cyclic dependency on snakemake
  doCheck = false;

  # Use nothing due to a cyclic dependency on snakemake
  pythonImportsCheck = [ ];

  meta = with lib; {
    description = "A Snakemake storage plugin that reads and writes from a locally mounted filesystem using rsync";
    homepage = "https://github.com/snakemake/snakemake-storage-plugin-fs";
    license = licenses.mit;
    maintainers = with maintainers; [ veprbl ];
  };
}
