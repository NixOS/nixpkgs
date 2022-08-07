{ lib
, fetchFromGitHub
, python3
, neovim
}:

with python3.pkgs; buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0lbz4w8hgxsw4k1pxafrl3rhydrvi5jc6vnsmkvnhh6l6rxlmvmq";
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

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A tool that helps controlling nvim processes from a terminal";
    homepage = "https://github.com/mhinz/neovim-remote/";
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
    mainProgram = "nvr";
  };
}
