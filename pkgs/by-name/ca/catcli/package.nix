{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "catcli";
  version = "1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-dAt9NysH3q5YC+vO9XTnapBxFZmC4vWwJ8SxT9CzCQE=";
  };

  postPatch = "patchShebangs . ";

  propagatedBuildInputs = with python3.pkgs; [
    anytree
    docopt
    fusepy
    pyfzf
    types-docopt
    cmd2
    natsort
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Command line catalog tool for your offline data";
    mainProgram = "catcli";
    homepage = "https://github.com/deadc0de6/catcli";
    changelog = "https://github.com/deadc0de6/catcli/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.all;
  };
}
