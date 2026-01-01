{
  lib,
  python3,
  fetchFromGitHub,
}:

<<<<<<< HEAD
python3.pkgs.buildPythonApplication rec {
  pname = "ghstack";
  version = "0.13.0";
=======
python3.pkgs.buildPythonApplication {
  pname = "ghstack";
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ezyang";
    repo = "ghstack";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-cRdwX5BVdpGjLPR0tpFYo62HYu/lmUzJE+vyxI9A4O8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires = ["uv_build>=0.6,<0.7"]' 'requires = ["uv_build>=0.6"]'
  '';

  build-system = [ python3.pkgs.uv-build ];
=======
    rev = "fa7e7023d798aad6b115b88c5ad67ce88a4fc2a6";
    hash = "sha256-Ywwjeupa8eE/vkrbl5SIbvQs53xaLnq9ieWRFwzmuuc=";
  };

  build-system = [ python3.pkgs.poetry-core ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dependencies = with python3.pkgs; [
    aiohttp
    click
    flake8
    importlib-metadata
    requests
    typing-extensions
  ];

<<<<<<< HEAD
  pythonImportsCheck = [ "ghstack.cli" ];
=======
  pythonImportsCheck = [ "ghstack" ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Submit stacked diffs to GitHub on the command line";
    homepage = "https://github.com/ezyang/ghstack";
    license = lib.licenses.mit;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      munksgaard
      shikanime
    ];
=======
    maintainers = with lib.maintainers; [ munksgaard ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ghstack";
  };
}
