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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-Y+Fofz4D/CWgdG3lOneadRu/VfJ23D4Dz751j9rUKNo=";
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
