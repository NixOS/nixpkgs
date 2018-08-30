{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonPackage rec {
  pname = "neovim-remote";
  version = "2.0.5";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "08qsi61ba5d69ca77layypzvi7nalx4niy97xn4w88jibnbmbrxw";
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
