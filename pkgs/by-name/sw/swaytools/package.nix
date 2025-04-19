{
  lib,
  python3Packages,
  fetchFromGitHub,
  slurp,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "swaytools";
  version = "0.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "swaytools";
    rev = version;
    sha256 = "sha256-UoWK53B1DNmKwNLFwJW1ZEm9dwMOvQeO03+RoMl6M0Q=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = [ slurp ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tmccombs/swaytools";
    description = "Collection of simple tools for sway (and i3)";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ atila ];
    platforms = lib.platforms.linux;
  };
}
