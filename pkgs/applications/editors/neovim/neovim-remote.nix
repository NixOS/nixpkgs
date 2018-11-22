{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonPackage rec {
  pname = "neovim-remote";
  version = "2.1.0";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0gri4d8gg5hvywffvj8r123d06x006qhink7d54yk6lvplw64gyc";
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
