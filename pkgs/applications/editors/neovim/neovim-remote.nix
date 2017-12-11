{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonPackage rec {
  name = "neovim-remote-${version}";
  version = "v1.9.0";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = version;
    sha256 = "1895whfiy3jvb4hyarl74hs4pklwi3m138qmsszcjppnwmvdzk54";
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
