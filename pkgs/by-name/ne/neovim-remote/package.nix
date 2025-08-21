{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  neovim,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "neovim-remote";
  version = "2.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mhinz";
    repo = "neovim-remote";
    rev = "v${version}";
    hash = "sha256-uO5KezbUQGj3rNpuw2SJOzcP86DZqX7DJFz3BxEnf1E=";
  };

  patches = [
    # Fix a compatibility issue with neovim 0.8.0
    (fetchpatch {
      url = "https://github.com/mhinz/neovim-remote/commit/56d2a4097f4b639a16902390d9bdd8d1350f948c.patch";
      hash = "sha256-/PjE+9yfHtOUEp3xBaobzRM8Eo2wqOhnF1Es7SIdxvM=";
    })
  ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pynvim
    psutil
  ];

  nativeCheckInputs = [
    neovim
    python3.pkgs.pytestCheckHook
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  pythonImportsCheck = [ "nvr" ];

  meta = with lib; {
    description = "Tool that helps controlling nvim processes from a terminal";
    homepage = "https://github.com/mhinz/neovim-remote/";
    license = licenses.mit;
    maintainers = with maintainers; [ edanaher ];
    platforms = platforms.unix;
    mainProgram = "nvr";
  };
}
