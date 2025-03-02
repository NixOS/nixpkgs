{
  lib,
  python3Packages,
  fetchPypi,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "cum";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qc6agka2g3kcnpnz0hbjic1s3260cr9bda0rlcyninxs1vndq0";
  };

  propagatedBuildInputs = [
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
    description = "comic updater, mangafied";
    mainProgram = "cum";
    homepage = "https://github.com/Hamuko/cum";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
