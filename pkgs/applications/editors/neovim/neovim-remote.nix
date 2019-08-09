{ stdenv, fetchFromGitHub, pythonPackages }:

with stdenv.lib;

pythonPackages.buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.1.9";
  disabled = !pythonPackages.isPy3k;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "1im7jq7vi2sbdrh95kbydbbfwdll6z9zh1w1vzh7ny1sigfphkpm";
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
