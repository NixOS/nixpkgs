{ lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "canaille";
  version = "0.0.54";
  pyproject = true;

  disabled = python3.pkgs.pythonOlder "3.9";

  src = fetchFromGitLab {
    owner = "yaal";
    repo = "canaille";
    rev = version;
    sha256 = "sha256-MowvgZsb4i0hsqQbOsPl0dbLxxW0J1KAqAz2xEQ+Yks=";
  };

  # See https://github.com/NixOS/nixpkgs/issues/103325
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=1.0.0" "poetry-core" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  build-system = with python3.pkgs; [ poetry-core setuptools babel ];

  dependencies = with python3.pkgs; [ flask flask-wtf pydantic-settings wtforms ];

}
