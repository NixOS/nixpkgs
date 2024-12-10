{
  lib,
  fetchFromGitHub,
  python3,
  neovim,
  fetchpatch,
}:

with python3.pkgs;
buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    sha256 = "0lbz4w8hgxsw4k1pxafrl3rhydrvi5jc6vnsmkvnhh6l6rxlmvmq";
  };

  patches = [
    # Fix a compatibility issue with neovim 0.8.0
    (fetchpatch {
      url = "https://github.com/mhinz/neovim-remote/commit/56d2a4097f4b639a16902390d9bdd8d1350f948c.patch";
      hash = "sha256-/PjE+9yfHtOUEp3xBaobzRM8Eo2wqOhnF1Es7SIdxvM=";
    })
  ];

  propagatedBuildInputs = [
    pynvim
    psutil
    setuptools
  ];

  nativeCheckInputs = [
    neovim
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "A tool that helps controlling nvim processes from a terminal";
    homepage = "https://github.com/mhinz/neovim-remote/";
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
    mainProgram = "nvr";
  };
}
