{ lib, python2Packages, fetchFromGitHub }:

python2Packages.buildPythonPackage rec {
  pname = "poretools";
  version = "unstable-2016-07-10";

  src = fetchFromGitHub {
    repo = pname;
    owner = "arq5x";
    rev = "e426b1f09e86ac259a00c261c79df91510777407";
    sha256 = "0bglj833wxpp3cq430p1d3xp085ls221js2y90w7ir2x5ay8l7am";
  };

  propagatedBuildInputs = [python2Packages.h5py python2Packages.matplotlib python2Packages.seaborn python2Packages.pandas];

  meta = {
    description = "a toolkit for working with nanopore sequencing data from Oxford Nanopore";
    license = lib.licenses.mit;
    homepage = "https://poretools.readthedocs.io/en/latest/";
    maintainers = [lib.maintainers.rybern];
  };
}
