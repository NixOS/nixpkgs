{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "cum";
  version = "0.9.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qc6agka2g3kcnpnz0hbjic1s3260cr9bda0rlcyninxs1vndq0";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    alembic
    beautifulsoup4
    click
    natsort
    requests
    sqlalchemy
  ];

  # tests seem to fail for `config` not being defined,
  # but it works once installed
  doCheck = false;

  # remove the top-level `tests` and `LICENSE` file
  # they should not be installed, and there can be issues if another package
  # has a collision (especially with the license file)
  postInstall = ''
    rm -rf $out/tests $out/LICENSE
  '';

  meta = with lib; {
    description = "Comic updater, mangafied";
    mainProgram = "cum";
    homepage = "https://github.com/Hamuko/cum";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
