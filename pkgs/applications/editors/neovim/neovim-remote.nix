{ lib
, fetchFromGitHub
, python3
, neovim
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0jlw0qksak4bdzddpsj74pm2f2bgpj3cwrlspdjjy0j9qzg0mpl9";
  };

  propagatedBuildInputs = [
    pynvim
    psutil
    setuptools
  ];

  checkInputs = [
    neovim
    pytestCheckHook
  ];

  disabledTests = [
    # these tests get stuck and never return
    "test_escape_filenames_properly"
    "test_escape_single_quotes_in_filenames"
    "test_escape_double_quotes_in_filenames"
  ];

  meta = with lib; {
    description = "A tool that helps controlling nvim processes from a terminal";
    homepage = "https://github.com/mhinz/neovim-remote/";
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
    mainProgram = "nvr";
  };
}
