{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.2.0";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0vvwygyar835z947d5zgjywyhl7ajj63z0l8sb7w9kj1w5snb43x";
  };

  propagatedBuildInputs = with pythonPackages; [ pynvim psutil ];

  meta = {
    description = "A tool that helps controlling nvim processes from a terminal";
    homepage = https://github.com/mhinz/neovim-remote/;
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
  };
}
