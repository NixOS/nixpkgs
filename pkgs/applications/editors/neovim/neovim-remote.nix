{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonPackage rec {
  name = "neovim-remote-${version}";
  version = "v1.6.0";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = version;
    sha256 = "0x01zpmxi37jr7j2az2bd8902h7zhkpg6kpvc8xmll9f7703zz2l";
  };

  propagatedBuildInputs = with pythonPackages; [ neovim psutil ];

  meta = {
    description = "A tool that helps controlling nvim processes from a terminal";
    homepage = https://github.com/mhinz/neovim-remote/;
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
  };
}
