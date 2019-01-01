{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonPackage rec {
  pname = "neovim-remote";
  version = "2.1.3";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0nx987af29ajlpwnwfc3z8gplxv69gj53s4bzm6pwwsfbhfakdah";
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
