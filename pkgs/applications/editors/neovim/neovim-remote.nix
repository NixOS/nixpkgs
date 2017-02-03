{ stdenv, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "neovim-remote-${version}";
  version = "v1.4.0";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = version;
    sha256 = "0msvfh27f56xj5ki59ikzavxz863nal5scm57n43618m49qzg8iz";
  };

  propagatedBuildInputs = [ pythonPackages.neovim ];
}
