{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonPackage rec {
  pname = "poretools";
  version = "0.6.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    repo = pname;
    owner = "arq5x";
    rev = "e426b1f09e86ac259a00c261c79df91510777407";
    sha256 = "0bglj833wxpp3cq430p1d3xp085ls221js2y90w7ir2x5ay8l7am";
  };

  propagatedBuildInputs = [pythonPackages.h5py pythonPackages.matplotlib pythonPackages.seaborn pythonPackages.pandas];

  meta = {
    description = "a toolkit for working with nanopore sequencing data from Oxford Nanopore";
    license = stdenv.lib.licenses.mit;
    homepage = http://poretools.readthedocs.io/en/latest/;
    maintainers = [stdenv.lib.maintainers.rybern];
  };
}
